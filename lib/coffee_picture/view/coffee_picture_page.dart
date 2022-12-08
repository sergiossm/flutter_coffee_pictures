// ignore_for_file: lines_longer_than_80_chars, no_default_cases

import 'package:coffee_pictures_repository/coffee_pictures_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coffee_pictures/coffee_picture/bloc/coffee_picture_bloc.dart';
import 'package:flutter_coffee_pictures/l10n/l10n.dart';
import 'package:shimmer_image/shimmer_image.dart';

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
      appBar: AppBar(
        title: Text(l10n.coffeePictureAppBarText),
      ),
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
                return const SizedBox(key: Key('coffeePictureView_empty_sizedBox'));
              }
            }

            final coffeePicture = state.coffeePicture!;
            return Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: ProgressiveImage(
                            image: coffeePicture.file,
                            height: double.maxFinite,
                            width: double.maxFinite,
                          ),
                        ),
                        if (state.downloadStatus == CoffeePictureDownloadStatus.success)
                          const SizedBox(key: Key('coffeePictureView_empty_sizedBox'))
                        else
                          Positioned(
                            top: 24,
                            right: 24,
                            child: OutlinedButton(
                              key: const Key('coffeePictureView_download_outlinedButton'),
                              onPressed: () {
                                if (state.downloadStatus == CoffeePictureDownloadStatus.initial) {
                                  context.read<CoffeePictureBloc>().add(
                                        CoffeePictureDownloadRequested(
                                          coffeePicture,
                                        ),
                                      );
                                }
                              },
                              child: () {
                                switch (state.downloadStatus) {
                                  case CoffeePictureDownloadStatus.downloading:
                                    return const CircularProgressIndicator.adaptive();
                                  case CoffeePictureDownloadStatus.initial:
                                    return const FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Icon(Icons.cloud_download_rounded),
                                    );
                                  default:
                                    return const SizedBox();
                                }
                              }(),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('coffeePictureView_refresh_floatingActionButton'),
        onPressed: () {
          context.read<CoffeePictureBloc>().add(const CoffeePictureRefreshRequested());
        },
        label: Text(l10n.coffeePictureRefreshFABText),
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}
