const mongoose = require('mongoose');

const contentSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
  },
  body: {
    type: String,
    required: true,
  },
  // Optionally, you can include more fields like tags, author, etc.
});

module.exports = mongoose.model('Content', contentSchema);
