The Chopper is a (increasingly complex) script to cut a single video file into shorter video files, based on a list of cut points. This is a work in progress, and I'm not sure it will completely work for everyone.

## Why?

I have over 150 videos of conversations with subject matter experts. The conversations run about an hour each. Within each hour are about 10 much shorter clips that can address specific questions, issues, and best practices. I want to be able to take the full video backlog and cut out those highlights. With 150+ videos, that requires some programatic intervention. Thus, The Chopper.

## Requirements

- [ffmpeg](https://ffmpeg.org/download.html)
- [turbolift](https://github.com/cloudnull/turbolift)

## Usage

Usage:
`$ chopper [flags]`

Required Flags:
`-f` file path. The path to your original video file.
`-c` cut list. A comma separated list of points to cut.
`-o` output path. The destination for finished clips.

Optional Flags:
`-A `Audio. Additionally export an mp3 version of the original video.
`-E` Export to Cloud Files. Provide a Rackspace Cloud Files container. Requires the installation of [turbolift](https://github.com/cloudnull/turbolift).

## To Do

- [ ] Create an example video and cut list
- [ ] Import origin video from Cloud Files
- [ ] Concatenate a standard intro/outro to each snippet before sending to Cloud Files
- [x] Return Cloud Files url for each snippet
- [x] Add a function to copy a version as mp3
