# Step 1: Compile Dart to AOT
FROM dart:stable AS build
WORKDIR /app
COPY . .
RUN dart pub get
RUN dart compile exe lib/socket_io_server.dart -o lib/socket_io_server.dart

# Step 2: Build runtime image
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/lib/socket_io_server.dart /app/lib/socket_io_server.dart
CMD ["/app/lib/socket_io_server.dart"]
