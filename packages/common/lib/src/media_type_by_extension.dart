part of '../common.dart';

MediaType? guessContentTypeByExtension(String extension) => switch (extension) {
      'html' => MediaType("text", "html"),
      'ico' => MediaType("image", "x-icon"),
      'css' => MediaType("text", "css"),
      'js' => MediaType("application", "javascript"),
      'lua' => MediaType("application", "lua"),
      'json' => MediaType("application", "json"),
      'png' => MediaType("image", "png"),
      'jpg' => MediaType("image", "jpeg"),
      'jpeg' => MediaType("image", "jpeg"),
      'gif' => MediaType("image", "gif"),
      'svg' => MediaType("image", "svg+xml"),
      'webp' => MediaType("image", "webp"),
      'woff' => MediaType("font", "woff"),
      'woff2' => MediaType("font", "woff2"),
      'ttf' => MediaType("font", "ttf"),
      'otf' => MediaType("font", "otf"),
      'eot' => MediaType("font", "eot"),
      'mp3' => MediaType("audio", "mpeg"),
      'wav' => MediaType("audio", "wav"),
      _ => null,
    };
