const Content = require('../models/Content');

// Get all content
exports.getAllContent = async (req, res) => {
  try {
    const content = await Content.find();
    res.status(200).json(content);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching content', error });
  }
};

// Create new content
exports.createContent = async (req, res) => {
  const { title, body } = req.body;
  try {
    const newContent = new Content({ title, body });
    await newContent.save();
    res.status(201).json(newContent);
  } catch (error) {
    res.status(500).json({ message: 'Error creating content', error });
  }
};

// Update content by ID
exports.updateContent = async (req, res) => {
  const { id } = req.params;
  const { title, body } = req.body;
  try {
    const updatedContent = await Content.findByIdAndUpdate(id, { title, body }, { new: true });
    if (!updatedContent) {
      return res.status(404).json({ message: 'Content not found' });
    }
    res.status(200).json(updatedContent);
  } catch (error) {
    res.status(500).json({ message: 'Error updating content', error });
  }
};

// Delete content by ID
exports.deleteContent = async (req, res) => {
  const { id } = req.params;
  try {
    const deletedContent = await Content.findByIdAndDelete(id);
    if (!deletedContent) {
      return res.status(404).json({ message: 'Content not found' });
    }
    res.status(200).json({ message: 'Content deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting content', error });
  }
};
