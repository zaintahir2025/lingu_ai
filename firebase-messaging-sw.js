// Import and configure the Firebase SDK
importScripts('https://www.gstatic.com/firebasejs/10.8.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.8.1/firebase-messaging-compat.js');

const firebaseConfig = {
    apiKey: "mock-api-key-for-web",
    authDomain: "lingu-ai-mock.firebaseapp.com",
    projectId: "lingu-ai-mock",
    storageBucket: "lingu-ai-mock.appspot.com",
    messagingSenderId: "1234567890",
    appId: "1:1234567890:web:mock-app-id"
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);
    const notificationTitle = payload.notification?.title || 'LinguAI';
    const notificationOptions = {
        body: payload.notification?.body || 'You have a new message.',
        icon: '/icons/Icon-192.png',
        data: payload.data
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
});

// Handle notification click to focus or open the app
self.addEventListener('notificationclick', function(event) {
    event.notification.close();
    
    // Attempt to extract the route from the data payload, default to root
    const route = event.notification.data?.route || '/';
    
    event.waitUntil(
        clients.matchAll({ type: 'window', includeUncontrolled: true }).then((windowClients) => {
            // Check if there is already a window/tab open with the target URL
            for (var i = 0; i < windowClients.length; i++) {
                var client = windowClients[i];
                // Focus the client if it's already open and navigate to the route
                if (client.url.includes(self.location.origin) && 'focus' in client) {
                    // Instruct the client window to navigate to the desired route
                    client.postMessage({ type: 'NAVIGATE', route: route });
                    return client.focus();
                }
            }
            // If no window is open, open a new one
            if (clients.openWindow) {
                return clients.openWindow(self.location.origin + '#' + route);
            }
        })
    );
});
