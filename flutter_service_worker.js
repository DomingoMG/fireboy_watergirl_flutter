'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "6a8c674dcdecc954d360ed7bb4884cef",
"assets/AssetManifest.bin.json": "17a871ac841632bbaafb722fbaf2aeab",
"assets/AssetManifest.json": "d734e56a565438f385e1be28d10c6fdd",
"assets/assets/audio/button_click.mp3": "47b70ce9b658908db79c10fbab552fe9",
"assets/assets/audio/button_hover.mp3": "1590a0f2c8082808d0c952e48e09b96d",
"assets/assets/audio/coin.mp3": "4add51a80d627efa5bd6be75d4105890",
"assets/assets/audio/death.mp3": "8db1f03894104389f16023c50de46a56",
"assets/assets/audio/fan.mp3": "f7157649f7013d11d251dd3f2e911f78",
"assets/assets/audio/final_level.mp3": "fccc9999dc53f661761299ddeb461d98",
"assets/assets/audio/fireboy_jump.mp3": "58d9e9619455b4ea9b5f073eb0d34c23",
"assets/assets/audio/level_complete.mp3": "84fa2c8e92b01672c58f4fe30343e783",
"assets/assets/audio/music_intro.mp3": "60aae402462bd539a04124dba16c7ebe",
"assets/assets/audio/music_level.mp3": "f8e91004827509f8205a9906cb7f4395",
"assets/assets/audio/watergirl_jump.mp3": "ea5693a1496353cb4551c28fa9b49b24",
"assets/assets/fonts/custom_font.TTF": "3db637d5fec2731f72520724c0d3db9d",
"assets/assets/images/background/background_1.png": "9fbfec6790abc86f37d9e8ada4d1da93",
"assets/assets/images/background/background_2.png": "c4764c6b03d9959533f5f841478ae108",
"assets/assets/images/background/transparent.png": "fcdf01ce458aa7af909582c5ca26688d",
"assets/assets/images/buttons/blue_activation_button.png": "a5661935d9d85e14938c22656e832c7c",
"assets/assets/images/buttons/green_activation_button.png": "8f13288f57e13a0309ca4446e999274f",
"assets/assets/images/buttons/orange_activation_button.png": "df1feb3fc43ae2fec86ecac11ee32d50",
"assets/assets/images/buttons/pink_activation_button.png": "6241c4ec68a2cab8fc38cfbf81e07c7a",
"assets/assets/images/buttons/white_activation_button.png": "12fa011b92b9c0a61a0bdfdf7f9ef3f5",
"assets/assets/images/buttons/yellow_activation_button.png": "5954aad4f0e305c6250c0c8cc4f4ee76",
"assets/assets/images/characters/fireboy.png": "34a4c801c785f58435ef5c317780239a",
"assets/assets/images/characters/fireboy_idle.png": "feefe440ae4b53a8cedb560113d8bdf7",
"assets/assets/images/characters/fireboy_jump.png": "b04d12afc4a738f6ea5d3004fa7d0d05",
"assets/assets/images/characters/fireboy_walk_left.png": "20c00b92ca6e1e50a3a71adc74e4ae07",
"assets/assets/images/characters/fireboy_walk_right.png": "c56a74de6eb2e64d83ef70fcbdb00b5c",
"assets/assets/images/characters/watergirl.png": "53726d5c1d8a9af10292f3d7934d2f78",
"assets/assets/images/characters/watergirl_idle.png": "70ff7f4b9d3eaebd0b498a93f6358135",
"assets/assets/images/characters/watergirl_jump.png": "b04d12afc4a738f6ea5d3004fa7d0d05",
"assets/assets/images/characters/watergirl_walk_left.png": "5667df5b18d0801572fb672a078e5e31",
"assets/assets/images/characters/watergirl_walk_right.png": "c57535ce385600e7c0f89560aa7f0668",
"assets/assets/images/doors/blue_door_close.png": "6155b9236d1ef66510ac0b129437cbcf",
"assets/assets/images/doors/red_door_close.png": "5943f385e7a34cfd20e7eb2f30a318fa",
"assets/assets/images/elevators/buttons/blue_button_elevator.png": "0f3316e5096d53bc8d2077088ba7a9e5",
"assets/assets/images/elevators/buttons/green_button_elevator.png": "099b3ad8f812cce10466abb88993ecec",
"assets/assets/images/elevators/buttons/orange_button_elevator.png": "3ef66573e8daa2df6a2f5b87fa1d34fa",
"assets/assets/images/elevators/buttons/pink_button_elevator.png": "20846d120abb2bd4db553610e3196ad6",
"assets/assets/images/elevators/buttons/white_button_elevator.png": "826ad0aa572eae2ca537c4ad3d5fa1d9",
"assets/assets/images/elevators/buttons/yellow_button_elevator.png": "d17a3be54f7762b64b783af80d991c47",
"assets/assets/images/elevators/horizontal/blue_elevator.png": "59bcbe1a667f19cf48ad87b9dc3a619b",
"assets/assets/images/elevators/horizontal/brown_elevator.png": "3c2a7f944168d430057920b96b18d159",
"assets/assets/images/elevators/horizontal/elevator.png": "56434292e5ff68ee66c402bde8647578",
"assets/assets/images/elevators/horizontal/green_elevator.png": "523f24ca2dd12515c3eecb0ba090f2e8",
"assets/assets/images/elevators/horizontal/pink_elevator.png": "80431b9384c59954ff3a9f0dbf3dadfc",
"assets/assets/images/elevators/horizontal/white_elevator.png": "f453b48375ff8262a2e803628616cb58",
"assets/assets/images/elevators/horizontal/yellow_elevator.png": "530dad47c8eeda63282d572c526293d4",
"assets/assets/images/elevators/vertical/blue_vertical_elevator.png": "5f48fde82ddcb6336d3d3fc3e0ccc9dd",
"assets/assets/images/elevators/vertical/brown_vertical_elevator.png": "826a2cb1c07950dd28069378e6080bc2",
"assets/assets/images/elevators/vertical/green_vertical_elevator.png": "19eab94dda1f8752ab482a1839a81aff",
"assets/assets/images/elevators/vertical/pink_vertical_elevator.png": "63e488164418593666748536d002ee93",
"assets/assets/images/elevators/vertical/white_vertical_elevator.png": "cfa55ed7693a090037ca11148066a88b",
"assets/assets/images/elevators/vertical/yellow_vertical_elevator.png": "e985105f3dd898ef448bcbc1ab325d1e",
"assets/assets/images/gems/blue_diamond.png": "d81d474cb08c570e7cfcd1d7fe5c7069",
"assets/assets/images/gems/green_diamond.png": "abf8c5c53e4f9c2729c2c6cd7921f731",
"assets/assets/images/gems/green_gem.png": "4bb6eb50d97e0385e12b784981093a34",
"assets/assets/images/gems/orange_gem.png": "5d410e7e01d6ab6bbd62112a8cb3e739",
"assets/assets/images/gems/purple_gem.png.png": "aa6ca07abb4724bbfe31baf21d3eaf90",
"assets/assets/images/gems/red_diamond.png": "6621a677c94cd719a7b1cf2f499dbb6c",
"assets/assets/images/joystick/controller_position.png": "1d03da2c868c8a0a75d6088fff6e15d6",
"assets/assets/images/joystick/controller_radius.png": "a21a9eafcf13739b2e12c1bff10087a2",
"assets/assets/images/levels/level_1.png": "e4abcff0432264a1ac562e8077494544",
"assets/assets/images/levels/level_2.png": "b39fa4cb1265353c66356e23510a6fae",
"assets/assets/images/levels/level_3.png": "d23181b549f1c12ffa8639be7c1d8009",
"assets/assets/images/levels/level_4.png": "6b58dbfcb6a98c240daf978e632c3020",
"assets/assets/images/levels/level_5.png": "b9cfa049d3f61cdde2f3d8052094bd39",
"assets/assets/images/levels/level_6.png": "04d25aac8ba4b2b01b6abc2944b23ce5",
"assets/assets/images/levers/blue_lever_switch.png": "abaeb3f4e6acaf923d0e959f2ce056bf",
"assets/assets/images/levers/green_lever_switch.png": "62bb89f5d16a48b1d366cbb3e256b4b0",
"assets/assets/images/levers/orange_lever_switch.png": "668d1cb62c0eb789713dbf799c05d23b",
"assets/assets/images/levers/pink_lever_switch.png": "ffdc0f5e7c779a6adad8c1aa4b4d0748",
"assets/assets/images/levers/white_lever_switch.png": "c938b5722f8f7be31dad40ffaf88846c",
"assets/assets/images/levers/yellow_lever_switch.png": "71b06912c0da1e21ff709082f70128ca",
"assets/assets/images/logo/fireboy_watergirl_logo.png": "564df73a6cb2d689febe5e4f7957371a",
"assets/assets/images/misc/ball.png": "b0ba99ace8aee16d63b40c2c2cab8139",
"assets/assets/images/misc/box.png": "aaeabf050a78aad57b6d05bcf26cfb2f",
"assets/assets/images/misc/move_box.png": "e911858f11fab68d7e134c414fa35617",
"assets/assets/images/puddles/large_acid_pool.png": "99dc30dd55729c88f73fe0f521e79b23",
"assets/assets/images/puddles/large_lava_pool.png": "218fe4dc890ca7b2d126d192f13bf190",
"assets/assets/images/puddles/large_water_pool.png": "311dbe85483dc31ecec38cc38abe8005",
"assets/assets/images/terrain/slope_tile_left.png": "0be2509bf8157124d05285cd6929d31a",
"assets/assets/images/terrain/slope_tile_right.png": "2dd88a689e65c7f960d4d493dc7ea9f1",
"assets/FontManifest.json": "ab2f4cfbe58cb3982e3fc83f36a081c1",
"assets/fonts/MaterialIcons-Regular.otf": "fa39fdec1e8be2ff86be062d07d5e96b",
"assets/NOTICES": "d07fe5c44ff7144c6361c0afe11c8f98",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "f0e65c4d50dbb7a5df230f44c43cf87d",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "d173e3caf9c1906c76bcd7efdffd09f0",
"icons/Icon-192.png": "5145a66e316cbb99f93f1e63a879cf22",
"icons/Icon-512.png": "ffe4e0e85c14d1f94c47535435da4358",
"icons/Icon-maskable-192.png": "5145a66e316cbb99f93f1e63a879cf22",
"icons/Icon-maskable-512.png": "ffe4e0e85c14d1f94c47535435da4358",
"index.html": "2d90ac5a0656d98780bacc41cbe1f776",
"/": "2d90ac5a0656d98780bacc41cbe1f776",
"main.dart.js": "80b4a87b45bdcac8b2e96c4411a862e3",
"manifest.json": "75b2f84204d7e2c292aae96e16c970b6",
"version.json": "d563868532f036666960e7206be524d5"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
