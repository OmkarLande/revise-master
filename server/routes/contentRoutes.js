const express = require('express');
const router = express.Router();
const contentController = require('../controllers/contentController');
const authMiddleware = require('../middleware/authMiddleware');

// Apply auth middleware if needed
// router.use(authMiddleware);

// Get all content
router.get('/',authMiddleware, contentController.getAllContent);

// Create new content
router.post('/',authMiddleware, contentController.createContent);

// Update content by ID
router.put('/:id',authMiddleware, contentController.updateContent);

// Delete content by ID
router.delete('/:id',authMiddleware, contentController.deleteContent);

module.exports = router;
