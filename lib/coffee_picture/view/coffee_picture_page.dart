// ignore_for_file: lines_longer_than_80_chars, no_default_cases

import 'package:coffee_pictures_repository/coffee_pictures_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coffee_pictures/coffee_picture/bloc/coffee_picture_bloc.dart';
import 'package:flutter_coffee_pictures/l10n/l10n.dart';
import 'package:transparent_image/transparent_image.dart';

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
            listenWhen: (previous, current) =>
                previous.status != current.status,
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
            listenWhen: (previous, current) =>
                previous.downloadStatus != current.downloadStatus,
            listener: (context, state) {
              if (state.downloadStatus == CoffeePictureDownloadStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content:
                          Text(l10n.coffeePictureDownloadErrorSnackbarText),
                    ),
                  );
              } else if (state.downloadStatus ==
                  CoffeePictureDownloadStatus.success) {
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
            if (state.coffeePicture == null ||
                state.status == CoffeePictureStatus.loading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
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
                          child: FadeInImage.memoryNetwork(
                            image: coffeePicture.file,
                            placeholder: kTransparentImage,
                            fit: BoxFit.cover,
                            height: double.maxFinite,
                            width: double.maxFinite,
                          ),
                        ),
                        Positioned(
                          top: 24,
                          right: 24,
                          child: OutlinedButton(
                            key: const Key(
                              'coffeePictureView_download_outlinedButton',
                            ),
                            onPressed: () {
                              if (state.downloadStatus ==
                                  CoffeePictureDownloadStatus.initial) {
                                context.read<CoffeePictureBloc>().add(
                                      CoffeePictureDownloadRequested(
                                        coffeePicture,
                                      ),
                                    );
                              }
                            },
                            child: state.downloadStatus ==
                                    CoffeePictureDownloadStatus.downloading
                                ? const CircularProgressIndicator.adaptive()
                                : const FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Icon(Icons.cloud_download_rounded),
                                  ),
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
          context
              .read<CoffeePictureBloc>()
              .add(const CoffeePictureRefreshRequested());
        },
        label: Text(l10n.coffeePictureRefreshFABText),
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}
