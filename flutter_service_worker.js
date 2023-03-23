'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "fd1bea7dc5b874c15ae6f3343fbe0d62",
"assets/assets/icons/non_vegan.png": "00d3ea642e6d737699c63d99ed787161",
"assets/assets/icons/vegan.png": "f6067d38af49899c110ab8a3929f14a0",
"assets/assets/images/103259c2": "9962b370272bf30794aac89cf71ac7b7",
"assets/assets/images/1f5c4881": "9962b370272bf30794aac89cf71ac7b7",
"assets/assets/images/2392644b": "aa731b0df4d42e915ebcc8a610065c93",
"assets/assets/images/44110d92": "3944e13a492cadc253c64c50f960b18b",
"assets/assets/images/832d310c": "9962b370272bf30794aac89cf71ac7b7",
"assets/assets/images/9a73d66": "cd55bced0dc83399a163cbd84a94e91e",
"assets/assets/images/acaaa64e": "cd55bced0dc83399a163cbd84a94e91e",
"assets/assets/images/affiche.jpg": "6fece867eb7a3da51e12deea80477ac4",
"assets/assets/images/affiche.png": "a287d7d3e29ea0770e48e8b232949552",
"assets/assets/images/animations.jpg": "b8dea86bcb252ef8fc06f9412a6fb731",
"assets/assets/images/avatar.png": "5d8bb5a4873c76f11d8663a90857ca1e",
"assets/assets/images/avatar.svg": "7b00886971e4382be5939288622e408d",
"assets/assets/images/b08c09f8": "9962b370272bf30794aac89cf71ac7b7",
"assets/assets/images/baby.png": "9839256adb2731ffdc3472b4bc30d81f",
"assets/assets/images/burger.jpg": "9962b370272bf30794aac89cf71ac7b7",
"assets/assets/images/casino-cards.jpg": "f89b9edb0ca54b7b3ae300ff69e5112c",
"assets/assets/images/cheesecake.jpg": "cd55bced0dc83399a163cbd84a94e91e",
"assets/assets/images/chicken-leg.jpg": "260597e9daec895e172fc8417aa7b9e9",
"assets/assets/images/chouffe.png": "d52450fab45639fec118d4cb83d83f21",
"assets/assets/images/club.jpg": "cf452171e6c56efdc3ce0b6ea97472b5",
"assets/assets/images/cremant_brut.png": "94cb07aa673e0041d3b7b40cba4627f7",
"assets/assets/images/cremant_brut_magnum.png": "6c221728739b453493b2783dd99f8741",
"assets/assets/images/cremant_rose.png": "aa731b0df4d42e915ebcc8a610065c93",
"assets/assets/images/duo.jpg": "9b27fd5b786baf1326b31bec0a12b125",
"assets/assets/images/e3df72f6": "9962b370272bf30794aac89cf71ac7b7",
"assets/assets/images/eclair.jpg": "076bfa3ec6b02998aca5f51801629938",
"assets/assets/images/event_table.jpg": "1bafba56b276a9fa6a8ae80f746ddb0a",
"assets/assets/images/f62100bb": "a7117dc4bce77980c3435e0afa760909",
"assets/assets/images/fleurs_dalsace.png": "6d76e6a30197f4856ab6fd673957aefe",
"assets/assets/images/gala.png": "1165218d581ba43a02a8b42bbebca27c",
"assets/assets/images/game-darts.jpg": "3944e13a492cadc253c64c50f960b18b",
"assets/assets/images/gewurztraminer.png": "5cb840f95e2e8a403ca5a2fd59da1035",
"assets/assets/images/hippodrome.jpg": "c9d0cfbd2d525202f5e8fb798b4e5062",
"assets/assets/images/muscat.png": "973ddea79061dc8fddddce56870d03ef",
"assets/assets/images/pastilla.jpg": "e149e5c0451062c0d41959bdd213fe25",
"assets/assets/images/photos.jpg": "6db6f8e4f761bfb09e17398ce89077ed",
"assets/assets/images/pinot_gris.png": "a920d2b5da632d7516291857ce9ced0d",
"assets/assets/images/pinot_noir.png": "da0fc0ee09b906022027a36b02e08421",
"assets/assets/images/primus_super_8.png": "d70e5c672435c1023304ddbf45be508d",
"assets/assets/images/scene-libre-alt.jpg": "73141221e9f425410f0232775be89965",
"assets/assets/images/scene-libre.jpg": "6d34b7027d0b79cfd631e464b0313178",
"assets/assets/images/slash_red.png": "47c68af45e5c9d1decceed3bda2918b2",
"assets/assets/images/soup.jpg": "98f7439f28005c25321c9b009ee60eda",
"assets/assets/images/talent-show.jpg": "2c2d0f39a9bf3bddc3156d490e2343ea",
"assets/assets/images/tbyr.jpg": "b438496d169fc7e3478a03371bdbffca",
"assets/assets/images/tdmd.jpg": "c7b51819275c5c8e8481b16bca79139a",
"assets/assets/images/toats.jpg": "a7117dc4bce77980c3435e0afa760909",
"assets/assets/json/drinks.json": "9e734cd874e1cca500368727fc3eb8af",
"assets/assets/json/events.json": "76b386a8dd4889946e1e8050d582f0b8",
"assets/assets/json/menu.json": "1ffd517cd1905521c0e40f9ae18b0fa0",
"assets/assets/json/palettes.json": "688793be0e90f58c99c006dd7c4b36ea",
"assets/assets/json/posts.json": "baef0e202c82c06adda58425121794ef",
"assets/assets/json/profiles.json": "0a228bb9868470757f8fdbb1cbf94f92",
"assets/assets/json/sncf.json": "1474849420ea7c97cd35983f8e05c81c",
"assets/assets/json/sncf.py": "6e94ffd30b34b6b356954d77ba1dd70c",
"assets/assets/json/sncf.xlsx": "1b9bfb76ff42d615597c2bd290991672",
"assets/assets/LICENSE": "051d97e583dc9d4eea44073c75e21c68",
"assets/assets/pictures/Camille.jpg": "4b0fc4073a49045fa1f2a3b1134bc9a2",
"assets/assets/pictures/Celestin.jpg": "c9164f287f47b6c0089487a7bda9e64b",
"assets/assets/pictures/Celia.jpg": "4016ed80ec06b54ba4cc0409989044c5",
"assets/assets/pictures/Charles.jpg": "602b56b88658852c6d856dd85fb4cf4f",
"assets/assets/pictures/eae6192e": "c7c8f2926e083aaa84134c0045864bf4",
"assets/assets/pictures/Elise.jpg": "566d1f96410cd97d88913c4942949c3c",
"assets/assets/pictures/Elliot.jpg": "3de34db03b191fb27049e45069e98cb9",
"assets/assets/pictures/Fleur.jpg": "18a4125f96014ee68f22839d16c0d0a2",
"assets/assets/pictures/Judith.jpg": "9277a8f623622c550428048e6cc9ae37",
"assets/assets/pictures/Julie(1).jpg": "de182c6065ec044b22265470ff2c482a",
"assets/assets/pictures/Lea.jpg": "46e3b33316984d9ddeccdb5918284504",
"assets/assets/pictures/Nicolas.jpg": "28a74432bb5c8d5e572698804fddf081",
"assets/assets/pictures/Nina.jpg": "ac9ef3f07693fb5d8e739c0809ca9cd7",
"assets/assets/pictures/Noemie.jpg": "c169f8c4bd51d53a534568de992393ee",
"assets/assets/pictures/Rachel.jpg": "c7c8f2926e083aaa84134c0045864bf4",
"assets/assets/pictures/ThomasB.jpg": "8dbc2af63184d6a50635a796eae8cc60",
"assets/assets/pictures/ThomasD.jpg": "f684e231008906a3f58b48a4b58c67f7",
"assets/assets/pictures/Yohann.jpg": "a56a89bfaad9f41e14713fbf32de9964",
"assets/assets/posts/images/15c7174f": "f12706bebed5a3e05ad54d58729767cd",
"assets/assets/posts/images/2d68a96f": "9c6d363bd1c617502555ab12604fb991",
"assets/assets/posts/images/30a9443e": "f12706bebed5a3e05ad54d58729767cd",
"assets/assets/posts/images/3f149df8": "0fc15e33763b995997b133e364838856",
"assets/assets/posts/images/452c1745": "9c6d363bd1c617502555ab12604fb991",
"assets/assets/posts/images/5dc82420": "9c6d363bd1c617502555ab12604fb991",
"assets/assets/posts/images/9d090821": "b68ca1c545d0aecb668c0d997b6f9b21",
"assets/assets/posts/images/affiche_poly.png": "10899651f989551fe4eeae431dfab5f6",
"assets/assets/posts/images/c5c3ef39": "aed0e2d4ac293ce87239035f47783921",
"assets/assets/posts/images/c8623da9": "6216f99b6a4dea45be7e7fa84f594510",
"assets/assets/posts/images/cover.jpg": "9c6d363bd1c617502555ab12604fb991",
"assets/assets/posts/images/doozescape.jpg": "aed0e2d4ac293ce87239035f47783921",
"assets/assets/posts/images/doozescapelogo.png": "3dc365aeb0167c477aec32ca16d8f34c",
"assets/assets/posts/images/edc79548": "aed0e2d4ac293ce87239035f47783921",
"assets/assets/posts/images/fortwenger.jpg": "0fc15e33763b995997b133e364838856",
"assets/assets/posts/images/fortwengerlogo.png": "ed5abd3331dbbcc1d92700e5f7d6e964",
"assets/assets/posts/images/gala.png": "1165218d581ba43a02a8b42bbebca27c",
"assets/assets/posts/images/insolitprod.png": "c5457abe5d8f8812b229dcf4fd4377d6",
"assets/assets/posts/images/insolitprodlogo.png": "9427ca54743148cea91b6fee9e89d665",
"assets/assets/posts/images/its.jpeg": "144f6bf71c933e36acef97fa3b591c5f",
"assets/assets/posts/images/itslogo.png": "f12706bebed5a3e05ad54d58729767cd",
"assets/assets/posts/images/jeffdebruges.jpg": "b68ca1c545d0aecb668c0d997b6f9b21",
"assets/assets/posts/images/jeffdebrugeslogo.png": "273cf44655c97584040830e7c9a00f83",
"assets/assets/posts/images/laguiole.jpg": "6216f99b6a4dea45be7e7fa84f594510",
"assets/assets/posts/images/laguiolelogo.png": "745091db7321c41b32939f4ad764c33b",
"assets/assets/posts/images/lessecretsdusablier.jpg": "a0c47d1ea9558be39ec83e96764c8496",
"assets/assets/posts/images/lessecretsdusablierlogo.png": "5e9bb5cd05303b16ca30b35a680e5e2e",
"assets/assets/posts/images/ninjastorm.jpg": "225fbcd19e0a3205edf2e16e27e92857",
"assets/assets/posts/images/ninjastormlogo.png": "9cf6a8803f2d0d24d89c7ba88ebd1996",
"assets/assets/posts/images/occitane.jpg": "c89ca702a1cd3eb1053298fe1956c06f",
"assets/assets/posts/images/occitanelogo.png": "423f8b2203aa043cc81b2e36ea36ed0f",
"assets/assets/posts/images/palaisdesthes.jpg": "79dfab5c868910b02ee83ab12d3f6e61",
"assets/assets/posts/images/palaisdestheslogo.png": "2466db3cda86b51b0ef22d6a6e806d1e",
"assets/assets/posts/images/saucisson-planche.png": "c343f126e67efb5d9148e35e7c9ad7c3",
"assets/assets/posts/images/shopforgeek.png": "29e232e895a3ae63b54f32febe0972dc",
"assets/assets/posts/images/shopforgeeklogo.png": "d9befd48aaf4407d1be7bdb35027fbc1",
"assets/assets/posts/images/straskart.jpg": "37a91c28ae5ef06a067cc6940d928112",
"assets/assets/posts/images/straskartlogo.png": "16725b21cd7931b4f9e7e34eb6123e43",
"assets/assets/posts/images/ugccinecite.jpg": "305cd270afc3dfb9a43ee2430eb8ab26",
"assets/assets/posts/images/ugccinecitelogo.png": "6b93c6b35516961fc6da42a393c03962",
"assets/assets/posts/images/virtualcenter.jpg": "388b41134b2b72b808c263239ada17e1",
"assets/assets/posts/images/virtualcenterlogo.png": "bbc282bbdc80f06313d87b5457488372",
"assets/assets/posts/movies/Gala_2022.mp4": "d6d514f62c144eb9a4cdd2215b124483",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/NOTICES": "ec2882c4eee2e02fe04e8b96812885a9",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/wakelock_web/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ae6c1fd6f6ee6ee952cde379095a8f3f",
"canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"favicon.png": "3a0e7a503c6dfc475983071beb47ca57",
"flutter.js": "f85e6fb278b0fd20c349186fb46ae36d",
"index.html": "16ec38a1b4c88cb701dfb4206d6000d6",
"/": "16ec38a1b4c88cb701dfb4206d6000d6",
"main.dart.js": "54a7af37257020e019e00e1747975b3f",
"manifest.json": "2ab4371f9eecce6252ed13a3f011f0b5",
"version.json": "16b485e0b4519c6d09cd1a08b4a7d1ea"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
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
