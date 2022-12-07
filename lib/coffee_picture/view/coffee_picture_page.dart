// ignore_for_file: lines_longer_than_80_chars

import 'package:coffee_pictures_repository/coffee_pictures_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coffee_pictures/coffee_picture/bloc/coffee_picture_bloc.dart';
import 'package:flutter_coffee_pictures/l10n/l10n.dart';

class CoffeePicturePage extends StatelessWidget {
  const CoffeePicturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoffeePictureBloc(
        coffeePicturesRepository: context.read<CoffeePicturesRepository>(),
      )..add(const CoffeePictureSubscriptionRequested()),
      child: const CoffeePictureView(),
    );
  }
}

class CoffeePictureView extends StatelessWidget {
  const CoffeePictureView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<CoffeePictureBloc, CoffeePictureState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if (state.status == CoffeePictureStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(l10n.coffeePictureErrorSnackbarText),
                    ),
                  );
              }
            },
          ),
          BlocListener<CoffeePictureBloc, CoffeePictureState>(
            listenWhen: (previous, current) => previous.downloadStatus != current.downloadStatus,
            listener: (context, state) {
              if (state.downloadStatus == CoffeePictureDownloadStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(l10n.coffeePictureDownloadErrorSnackbarText),
                    ),
                  );
              } else if (state.downloadStatus == CoffeePictureDownloadStatus.success) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(l10n.coffeePictureDownloadSnackbarText),
                    ),
                  );
              }
            },
          ),
        ],
        child: BlocBuilder<CoffeePictureBloc, CoffeePictureState>(
          builder: (context, state) {
            if (state.coffeePicture == null) {
              if (state.status == CoffeePictureStatus.initial || state.status == CoffeePictureStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state.status != CoffeePictureStatus.success) {
                return const SizedBox();
              }
            }

            final coffeePicture = state.coffeePicture!;
            return Stack(
              children: [
                Center(
                  child: Text(coffeePicture.file),
                ),
                Positioned(
                  top: 80,
                  right: 20,
                  child: state.downloadStatus == CoffeePictureDownloadStatus.initial
                      ? TextButton.icon(
                          onPressed: () {
                            context.read<CoffeePictureBloc>().add(CoffeePictureDownloadRequested(coffeePicture));
                          },
                          icon: const Icon(Icons.cloud_download_rounded),
                          label: Text('Download'),
                        )
                      : state.downloadStatus == CoffeePictureDownloadStatus.downloading
                          ? const CircularProgressIndicator.adaptive()
                          : const SizedBox(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
