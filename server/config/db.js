const mongoose = require('mongoose');

exports.connect = () => {
    mongoose.connect(process.env.DB_URL || 'mongodb://localhost:27017/test');
    mongoose.connection.on('connected', () => {
        console.log('Connected to MongoDB!!');
    });
    mongoose.connection.on('error', (err) => {
        console.log('Error connecting to MongoDB', err);
    });
    }
