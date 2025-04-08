import {AGATE_HTTPS, JUKERSTONE_HOSTNAME, SOURCE_HTTPS} from './hostnames';

export const API = ({id, query}: {id?: string; query?: string}) => ({
  jukerstone: {
    config: {
      variables: `${JUKERSTONE_HOSTNAME}/variables`,
    },
    login: {
      otp: `${JUKERSTONE_HOSTNAME}/one-time-passcode`,
      implicit: `${JUKERSTONE_HOSTNAME}/implicit`,
    },
    stream: `${JUKERSTONE_HOSTNAME}/stream`,
    jukepod: {
      stream: `${JUKERSTONE_HOSTNAME}/stream/${id}`,
      queue: `${JUKERSTONE_HOSTNAME}/jukepod/queue`,
    },
    desktop: {
      initialize: `${JUKERSTONE_HOSTNAME}/init`,
    },
    security: {
      // youtube: `${AGATE_HTTPS}/${id}`,
      youtube: `${SOURCE_HTTPS}/watch?v=${id}`,
    },
    spotify: {
      search: {
        track: {
          isrc: `${JUKERSTONE_HOSTNAME}/spotify/search/isrc/${id}`,
        },
        album: `${JUKERSTONE_HOSTNAME}/spotify/search/album/${query}`,
        artistThumbnails: `${JUKERSTONE_HOSTNAME}/spotify/search/artist/thumbnails/${query}`,
        artist: `${JUKERSTONE_HOSTNAME}/spotify/search/artist/${query}`,
      },
      artist: {
        id: `${JUKERSTONE_HOSTNAME}/spotify/artist/${id}`,
        topTracks: `${JUKERSTONE_HOSTNAME}/spotify/artist/${id}/top-tracks`,
        relatedArtists: `${JUKERSTONE_HOSTNAME}/spotify/artist/${id}/related-artists`,
        thumbnailAlbum: `${JUKERSTONE_HOSTNAME}/spotify/artist/${id}/albums/thumbnails`,
      },
      track: `${JUKERSTONE_HOSTNAME}/spotify/track/${id}`,
      playlist: {
        id: `${JUKERSTONE_HOSTNAME}/spotify/playlist/${id}`,
        tracks: `${JUKERSTONE_HOSTNAME}/spotify/playlist/${id}/tracks`,
      },
      album: {
        id: `${JUKERSTONE_HOSTNAME}/spotify/album/${id}`,
        tracks: `${JUKERSTONE_HOSTNAME}/spotify/album/${id}/tracks`,
      },
    },
    genius: {
      search: {
        song: `${JUKERSTONE_HOSTNAME}/genius/search/song/${query}`,
      },
      artist: {
        id: `${JUKERSTONE_HOSTNAME}/genius/artist/${id}`,
        topTracks: `${JUKERSTONE_HOSTNAME}/genius/artist/${id}/songs`,
      },
    },
  },
});
