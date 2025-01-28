const express = require('express');
const app = express();

// Define the port to listen on
const PORT = 80;

// Root endpoint to return "Hello, Techie!"
app.get('/', (req, res) => {
    res.send('Hello, Techie!');
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://0.0.0.0:${PORT}`);
});
