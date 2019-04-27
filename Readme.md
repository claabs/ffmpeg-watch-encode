# ffmpeg-watch-encode

A Docker container designed to watch a directory and encode a `.mkv` file at a desired CRF (Constant Rate Factor).
The purpose of this is to reduce the file size of 4K HDR `.mkv`'s by reducing the overall quality, but preserving all audio and subtitle streams.

Designed to be deployed to Unraid.

### Build and tag the image
```sh
docker build . -t ffmpeg
```

### Run the container with mounted volumes
```sh
# Run from cloned repository
docker run -v `pwd`/watch:/watch -v `pwd`/output:/output -v `pwd`/copy:/copy -v `pwd`/logs:/logs ffmpeg

# Run from Docker Hun
docker run -v `pwd`/watch:/watch -v `pwd`/output:/output -v `pwd`/copy:/copy -v `pwd`/logs:/logs charlocharlie/ffmpeg-watch-encode
```

### Stopping the container
For some reason you can't CTRL-C out of the above command, so to stop the container, open another terminal and do:
```sh
docker container ls
# Copy the container ID for the ffmpeg-watch-encode container
docker container stop <container ID>
```

## Options
You can configure some encoding options with environment variables:

| Variable Name | Default | Description                                                                                                        |
|---------------|---------|--------------------------------------------------------------------------------------------------------------------|
| ENCODER       | libx265 | Pick the encoder to use. The below options may behave differently when not using the libx265 encoder.              |
| CRF           | 28      | A quality factor for the encode from 0.0-58.0. Lower numbers are better quality and higher file size.              |
| PRESET        | medium  | x265 encoder preset. Set as low as you're willing to wait. See https://x265.readthedocs.io/en/default/presets.html |
| TUNE          | (none)  | x265 encoder tuning. See https://x265.readthedocs.io/en/default/presets.html#tuning                                |
