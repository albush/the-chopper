The Chopper is a (increasingly complex) script to cut a single video file into shorter video files, based on a list of cut points. This is a work in progress, and I'm not sure it will completely work for everyone.

## Why?

I have over 150 videos of conversations with subject matter experts. The conversations run about an hour each. Within each hour are about 10 much shorter clips that can address specific questions, issues, and best practices. I want to be able to take the full video backlog and cut out those highlights. With 150+ videos, that requires some programatic intervention. Thus, The Chopper.

## Requirements

- [ffmpeg](https://ffmpeg.org/download.html)
- [turbolift](https://github.com/cloudnull/turbolift)

## Usage

    $ cutter [PATH_TO_VIDEO_FILE] [PATH_TO_CUT_LIST] [PATH_TO_OUTPUT_DIRECTORY] (Optional) [RACKSPACE_CLOUDFILES_CONTAINER]

- `[PATH_TO_VIDEO_FILE]` Can be any video input recognized by `ffmpeg`
- `[PATH_TO_CUT_LIST]` The cut list is a comma separated text file as follows:
  - `start_time,end_time,clip_title ` in the format `HH:MM:SS`
  - eg:
```
00:00:33,00:02:45,First topic of conversation
00:03:12,00:23:37,A really long topic
```
- `[PATH_TO_OUTPUT_DIRECTORY]` is the destination directory for the videos when completed.
- `[RACKSPACE_CLOUDFILES_CONTAINER]` is optional, and allows you to upload the finished videos to a Rackspace Cloud Files container. You'll need to install and configure turbolift.

## To Do

- [ ] Create an example video and cut list
- [ ] Import origin video from Cloud Files
- [ ] Concatenate a standard intro/outro to each snippet before sending to Cloud Files
- [ ] Return Cloud Files url for each snippet
- [ ] Add a function to copy a version as mp3
