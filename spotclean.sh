#!/bin/bash

usage="$(basename "$0") [-h] [-t XXXX] [-p NNNN] [-u NNNN] -- Spotify Bulk Playlist Cleanup

Options:
    -h  show help
    -t  set Spotify API Access Token (required)
    -p  approximate number of playlists in your account. If you're not sure, aim super high (required)
    -u  Spotify User ID (required)"

while getopts ':ht:u:p:' option; do
  case "$option" in
  h)
    echo "$usage"
    exit 1
    ;;
  p)
    PLAYLIST_NUM=$OPTARG
    ;;
  t)
    ACCESS_TOKEN=$OPTARG
    ;;
  u)
    USER_ID=$OPTARG
    ;;
  \?)
    printf "Invalid option: -%s\n" "$OPTARG" >&2
    echo "$usage" >&2
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

# Check prerequisites:
if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed.' >&2
  exit 1
fi
if ! [ -x "$(command -v curl)" ]; then
  echo 'Error: curl is not installed.' >&2
  exit 1
fi

# Validate input
if [ -z "${PLAYLIST_NUM}" ]; then
  echo "Playlist count not provided"
  echo "$usage" >&2
  exit 1
fi

if [ -z "${ACCESS_TOKEN}" ]; then
  echo "Spotify API Access Token not provided"
  echo "$usage" >&2
  exit 1
fi

if [ -z "${USER_ID}" ]; then
  echo "Spotify User ID not provided"
  echo "$usage" >&2
  exit 1
fi

COUNTER=0
while [ $COUNTER -lt "${PLAYLIST_NUM}" ]; do
  echo "Processing playlist #${COUNTER}"
  CURR_PLAYLIST_DATA=$(curl -s "https://api.spotify.com/v1/me/playlists?limit=1&offset=${COUNTER}" -H "Authorization: Bearer ${ACCESS_TOKEN}" -X GET)
  if [[ $CURR_PLAYLIST_DATA == *"error"* ]]; then
    printf "Error calling the Spotify API!\n%s\n" "$CURR_PLAYLIST_DATA" >&2
    exit 1
  else
    CURR_PLAYLIST_NUM=$(${CURR_PLAYLIST_DATA} | jq -r '.items[].tracks.total')
  fi

  if [ "${CURR_PLAYLIST_NUM}" == "0" ]; then

    echo "Found playlist with 0 tracks!"

    ID_TO_DELETE=$(curl -s "https://api.spotify.com/v1/me/playlists?limit=1&offset=${COUNTER}" -H "Authorization: Bearer ${ACCESS_TOKEN}" -X GET | jq -r '.items[].id')

    echo "Playlist ID to delete=${ID_TO_DELETE}"

    curl -s "https://api.spotify.com/v1/users/${USER_ID}/playlists/${ID_TO_DELETE}/followers" -H "Authorization: Bearer ${ACCESS_TOKEN}" -X DELETE | jq -r '.items[].id'
  fi

  ((COUNTER++))
done
