const express = require('express');
const session = require('express-session');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

const db = require('./config/db');
const userRoutes = require('./routes/userRoutes');
const contentRoutes = require('./routes/contentRoutes');

const app = express();
db.connect();
app.use(express.json());
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(
    session({
        secret: process.env.SESSION_SECRET,
        resave: false,
        saveUninitialized: false,
        cookie: { maxAge: 60 * 60 * 1000 } 
    })
);

app.use('/user', userRoutes);
app.use('/content', contentRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
