'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "9faf50a05d6d45e4f063102a80355467",
"version.json": "533144f2a0b680b5d9abc225c55bfc4a",
"index.html": "12edea3f04ea4f84586a6f7d12f7c6d8",
"/": "12edea3f04ea4f84586a6f7d12f7c6d8",
"main.dart.js": "c5981c34c4bc7c6c51c361a72aadc65a",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"icons/Icon-192.png": "36cd890adf35a10f86a05518b81e6b28",
"icons/Icon-maskable-192.png": "36cd890adf35a10f86a05518b81e6b28",
"icons/Icon-maskable-512.png": "ec692651ab701e0390a23407a6bc2790",
"icons/Icon-512.png": "ec692651ab701e0390a23407a6bc2790",
"manifest.json": "0630a35a8afb08201c9d0876cc8b7350",
".git/config": "ceff4021e6541bdc05296d1a1f5e64b2",
".git/objects/95/03579de7bdad44e5b249d660b2f86819f4c46b": "347a82097ab40feb1624497dc3977477",
".git/objects/50/08ddfcf53c02e82d7eee2e57c38e5672ef89f6": "d18c553584a7393b594e374cfe29b727",
".git/objects/68/1cdedaca15be9eb6664e2e59196a8d153ebeae": "7392268c6b0e52b5340a5b981d11ed6b",
".git/objects/35/9cab337ae1b0fad3ab5cc4f55fe3348e9f0480": "053c16f3b6dc17b2bfba9767d13792ea",
".git/objects/51/189bbc9f632c4dab08f24f78507a0ca9807ab1": "9fc0383a26cc0a6c9f303b8c169cee50",
".git/objects/58/b007afeab6938f7283db26299ce2de9475d842": "6c6cbea527763bb3cdff2cecfee91721",
".git/objects/58/356635d1dc89f2ed71c73cf27d5eaf97d956cd": "f61f92e39b9805320d2895056208c1b7",
".git/objects/94/f7d06e926d627b554eb130e3c3522a941d670a": "77a772baf4c39f0a3a9e45f3e4b285bb",
".git/objects/94/a15b86c42dbed65f2a93576b8a495589894995": "9735382b02d71dd32ffef70dc0cbe5df",
".git/objects/02/de198c0a561ef1d98f9c5114c73bead5fe49bd": "6fc9c4e9a7f8bda466a87315f9501fa7",
".git/objects/ac/d9e872cf2d21e99fb0b061a5e820249fc48106": "2021c229553d81e0dfdc3a4111fed3fc",
".git/objects/be/c7d973c3d042a9800afc5d6f87062319d4d193": "c4d05772a196c0bbe6cbc3d4ed04ef9f",
".git/objects/b3/d8b7b592b60eb4c2bdb68679c29d69f8108bc5": "76e309f1aa24712b909de5fbb7efe2de",
".git/objects/b3/ebbd38f666d4ffa1a394c5de15582f9d7ca6c0": "23010709b2d5951ca2b3be3dd49f09df",
".git/objects/b4/a3ecb9428e2a4b8aff40c099e1c27d64a928f0": "6e4bc29289eb6be950713f1b329eaf0d",
".git/objects/d1/098e7588881061719e47766c43f49be0c3e38e": "f17e6af17b09b0874aa518914cfe9d8c",
".git/objects/bc/e2e53c575711d6aa3bb6a18877dc3896a901c1": "83830ba99ef172f3ecc94a912125a2ad",
".git/objects/ae/042ba0575180be7dd8f3b94cc0c55876d19b60": "82758eaf5cdd549cc21875cec32add2b",
".git/objects/d8/4c10d5eeca252b3e58407684d0027f91b1ba8d": "f7d2923f2b71ff6348fbb488236bbf75",
".git/objects/c9/bf8af1b92c723b589cc9afadff1013fa0a0213": "632f11e7fee6909d99ecfd9eeab30973",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/e3/25023cd9a6a32ecdc501c76b345ccc34eb8572": "0deee74cd43d377ae48d9fe712334c88",
".git/objects/fe/521417b5c9b6a2cd42c4911ba8998052f5fefb": "64e9b2ecc9af0840034ce4a111da2036",
".git/objects/c1/f1c7fcbbe8e0aeba6cf136445bd5041a6d4529": "4fc99b47e05c8e89684c6e2a6a95cf47",
".git/objects/20/cb2f80169bf29d673844d2bb6a73bc04f3bfb8": "b807949265987310dc442dc3f9f492a2",
".git/objects/20/1afe538261bd7f9a38bed0524669398070d046": "82a4d6c731c1d8cdc48bce3ab3c11172",
".git/objects/18/eb401097242a0ec205d5f8abd29a4c5e09c5a3": "4e08af90d04a082aab5eee741258a1dc",
".git/objects/4b/825dc642cb6eb9a060e54bf8d69288fbee4904": "75589287973d2772c2fc69d664e10822",
".git/objects/7c/10915e240b742fac5c58eb70f2ddbc36a3842b": "5684ef0769759e3fd040d84e1080b300",
".git/objects/42/6e35fa54de2787c56bcdf64a81a2c0469fe643": "1eb4554aa87c4be7be4d2e285157ab47",
".git/objects/1f/45b5bcaac804825befd9117111e700e8fcb782": "7a9d811fd6ce7c7455466153561fb479",
".git/objects/1a/b05e0c55efaf524bd361ab16a1ecd040d42dfc": "05f748d36792f64b0ba00501b5b63cf7",
".git/objects/17/aef985952f0f0506807439db53d1f03a042eea": "0d877adfa36a04c674a9ce90d497bb45",
".git/objects/43/1d4b31bedd28dc93ba844bbf96314f4ce3ebed": "b323aef3bba801fa36cd10a6ae530490",
".git/objects/09/4bb6ae24f0cd847d40cb4cc4a2434f2ec9b83b": "b9e6d850322c11db635bcf0a45b762ff",
".git/objects/09/ea2af7ddd83c8d1905020c16cd644f69548a3e": "119bf38ac2b67fc9891df610a8e316ef",
".git/objects/3f/4711f415d23482da898143d28d7307e5ef4ab3": "76105fbd980516bdd597f3fc6b6b9588",
".git/objects/5b/e8df1582ace00412ff750a93c70f9b5a87ed87": "b8df6a39939f7aca1ca1166a13f3d614",
".git/objects/08/96cc9619f699e76f252445bc7d330345a9a3db": "5eda2f35d636e2535a049f350dc6a212",
".git/objects/39/3922372f8bd877f1420c184e690ca01670c55c": "711e8d71c42b41211dc05dadf1a65c25",
".git/objects/0f/f252055cfbfb7ea22283fe0ce11e1020532d07": "46d3fe00aa669b1ddc256937cae5c109",
".git/objects/0f/3e3258e690243098415125bb17e426b76f51b9": "cfb4f74f70ec9b2d8d9b4a353d72802d",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/ba/5317db6066f0f7cfe94eec93dc654820ce848c": "9b7629bf1180798cf66df4142eb19a4e",
".git/objects/b1/17a15251b384de0f0635d9cc355f580fa0833e": "6f6355bfe825c2f1a4fe0ed3613a67af",
".git/objects/dc/56a0caa2b79ece384bdcfbbc52caeda70f6bd5": "647b2ce3f43b1691f2dba47cbffb67be",
".git/objects/d5/6795874b868ac21b2d938d635a5d9d5a88fcbe": "0a0a38d249e37caa1237c0b025f94c50",
".git/objects/b7/abe83eba5083a929c572dc61635a6d62fe74d5": "339433c986ac62f6162001750bb387b2",
".git/objects/ef/4dd7aa395c850bdeef1d2024afdc802b6c77da": "3985f42ca4cb1b26086e43e8cb9cfd82",
".git/objects/ef/94d4ae267c628bd0348383725ed41813587bc5": "2f57e5636fbc32830c36a688f34e53c1",
".git/objects/c3/7d0786dfa70b367ffe9882f7ba0160400e1eb5": "16acc4efb5c310013ed9a7bfa5520e9c",
".git/objects/e1/b736f51f11ee9b6a60f3912fbc927fda822e4b": "47229587112f4559df472c321a457e25",
".git/objects/cd/e0b099199f5e9f828691f990b6988914644e6a": "a28338aa50ad751d72435315fa9c6d8a",
".git/objects/e6/9de29bb2d1d6434b8b29ae775ad8c2e48c5391": "c70c34cbeefd40e7c0149b7a0c2c64c2",
".git/objects/f9/8b5ec08a86d4bb2e721923c02cf69c0d540243": "707fd0e4511683633458d88474ad1207",
".git/objects/79/ba5fd01b7aa74086e0c3392f65aa6ecf6f5db0": "f5957e5882d902aa1296fcf53a00caad",
".git/objects/48/dad3c2fa58b5b985dc6d174c41e821c2381d14": "1bb6d00db212f1219c2733bb97db0ae9",
".git/objects/4a/394a150e10d36db06fb2cfa8056e530f456829": "cb56d1b41ea0668c28a13c85a83c5a95",
".git/objects/15/3b97c8dd868bbc6f4df48f6af01f2a95665a18": "405a6b1ea2fbf6515cd5fb4a47d6f4df",
".git/objects/8c/c7fde61835d333d5f022eb3fa99861d6adb48e": "45db0ea272fafbc01e2310889bee127a",
".git/objects/85/6a39233232244ba2497a38bdd13b2f0db12c82": "eef4643a9711cce94f555ae60fecd388",
".git/objects/71/3f932c591e8f661aa4a8e54c32c196262fd574": "66c6c54fbdf71902cb7321617d5fa33c",
".git/objects/49/adebdb511c8c293b28db3f6792e5bac28cdc32": "ba6a3971e7f06834fd6ec3844372ce17",
".git/objects/40/19cf1914dcfec514dc2db789bbc7d42292d0a1": "527e5dee9bd05b94a8ecf689cb3a4a2e",
".git/objects/2e/66f73322d6f693f4dde485afeaf562cd77304e": "b180824da9d06a21cd2b8458063539f4",
".git/objects/2b/a127b180b9e99e7182d46b6f7d0440dfebfad3": "e6ece595435f1f2c1fbb37937b1e8f6a",
".git/objects/2b/a68ded2108ead55c56dcc4fc1e79d8b2640b75": "6b3c50c80eb40e6d4aa4bec1477a71b1",
".git/objects/78/c374fccd6d7a3f572b70f4dd8f811fac4f9ad5": "590d3f20f8a94f5181c478c106f04de6",
".git/objects/8e/4bc10052d5c379a880e13a71e2bb3bd8733ec8": "146665c313b51916b1c42bb7687264ac",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "d0a75626f05b652e635e905021dd6078",
".git/logs/refs/heads/main": "d0a75626f05b652e635e905021dd6078",
".git/logs/refs/remotes/origin/main": "617d732ee8fff9043d1a91b9d4418dc5",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/refs/heads/main": "24226c8730af99c110dc76fb018aa7b1",
".git/refs/remotes/origin/main": "24226c8730af99c110dc76fb018aa7b1",
".git/index": "5782761caed1efc73d73257617268a49",
".git/COMMIT_EDITMSG": "4df653f6fbb299f2e9df05d4f9e1f646",
"assets/images/background.png": "846b7f191d7b8e4c9c7a3b068c547ee7",
"assets/images/logo.png": "bca64fc92604a283cc1e4ceb2f27e203",
"assets/images/logo.svg": "beca904b9db3b11538cccec33d13fbd3",
"assets/AssetManifest.json": "32a5ac3cd6ad9eeee2f43b83f01e7a3a",
"assets/NOTICES": "a01d333debb09f7655c6af828b4d3655",
"assets/FontManifest.json": "db8f453ee5bd623ef9ffbe9d7a009cf7",
"assets/AssetManifest.bin.json": "65ee479c075eeb7353e5ca6db0a4ee11",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/material_symbols_icons/lib/fonts/MaterialSymbolsRounded.ttf": "80efa3047a098a7e3a0d5aafbd7e544f",
"assets/packages/material_symbols_icons/lib/fonts/MaterialSymbolsOutlined.ttf": "3a90d6586ff7c346d42697dc4133adcd",
"assets/packages/material_symbols_icons/lib/fonts/MaterialSymbolsSharp.ttf": "63ce58233151387be3c0c5131754adc5",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "b94c070976bfcfc5cfd70318ddbcd780",
"assets/fonts/MaterialIcons-Regular.otf": "9647ff16a72476018e18bd627d782596",
"assets/assets/images/background.png": "846b7f191d7b8e4c9c7a3b068c547ee7",
"assets/assets/images/logo.png": "bca64fc92604a283cc1e4ceb2f27e203",
"assets/assets/images/logo.svg": "beca904b9db3b11538cccec33d13fbd3",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03"};
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
