
$(function() {
  var style = {
    'MultiPoint': [new ol.style.Style({
      image: new ol.style.Circle({
        // fill: new ol.style.Fill({
        //   color: 'rgba(255,255,0,0.4)'
        // }),
        radius: 5,
        stroke: new ol.style.Stroke({
          color: '#fff',
          width: 1
        })
      })
    })],
    'LineString': [new ol.style.Style({
      stroke: new ol.style.Stroke({
        color: '#f00',
        width: 3
      })
    })],
    'MultiLineString': [new ol.style.Style({
      stroke: new ol.style.Stroke({
        color: '#000',
        width: 2
      })
    })]
  };

  // var base_network_layer = (function() {
  //   var source = new ol.source.Vector({
  //     url: '/basenetwork',
  //     format: new ol.format.WKT({ splitCollection: true })
  //   });

  //   source.on('addfeature', function(e) {
  //     e.feature.getGeometry().transform('EPSG:4326', 'EPSG:3857')

  //   })

  //   var bnl = new ol.layer.Vector({
  //     source: source,
  //     style: function(feature, resolution) {
  //       return style[feature.getGeometry().getType()]
  //     }
  //   });

  //   // bnl.on('change', function(e) { 
  //   //   console.log('change!');
  //   //   console.log(e.target.getExtent())
  //   // })

  //   return bnl;
  // })()


  var tiles =  new ol.layer.Tile({ source: new ol.source.OSM() });

  var tlayer = (function() {

    source = new ol.source.Vector({
      url: '/geojson',
      format: new ol.format.GeoJSON()
    });

    source.on('addfeature', function(e) {
      console.log('addfeature')
      console.log(e.feature.getGeometry())
      e.feature.getGeometry().transform('EPSG:4326', 'EPSG:3857')
    });

    return new ol.layer.Vector({
      source: source,
      style: function(feature, resolution) {
        return style[feature.getGeometry().getType()]
      }
    });
  })();


  window.map = new ol.Map({
    layers: [ tiles, tlayer ],
    target: 'map',
    view: new ol.View({
      center: [ -48473387.07166993, 4881813.240117887],
      zoom: 15
    })
  });

// map.getView().setCenter(ol.extent.getCenter(map.getLayers().item(1).getSource().getExtent()))
//   bnl.getSource
//   map.on('change:view', function(e) {
//     console.log('change:view');
//     console.log(e.target)
//   })
});


