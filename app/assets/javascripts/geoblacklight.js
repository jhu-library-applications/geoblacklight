//= require handlebars.runtime
//= require geoblacklight/geoblacklight
//= require geoblacklight/basemaps
//= require geoblacklight/controls
//= require geoblacklight/viewers
//= require geoblacklight/modules/download
//= require geoblacklight/modules/geosearch
//= require geoblacklight/modules/help_text
//= require geoblacklight/modules/home
//= require geoblacklight/modules/item
//= require geoblacklight/modules/layer_opacity
//= require geoblacklight/modules/metadata
//= require geoblacklight/modules/metadata_download_button
//= require geoblacklight/modules/relations
//= require geoblacklight/modules/util

//= require geoblacklight/downloaders


// additional leaflet base layers
GeoBlacklight.Basemaps.esri =  L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}', {
  attribution: false,
  maxZoom: 18,
  worldCopyJump: true,
  detectRetina: true,
  noWrap: false
});
