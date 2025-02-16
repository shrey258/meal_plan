const mongoose = require('mongoose');

const mealSchema = new mongoose.Schema({
    day: {
        type: String,
        required: true,
        enum: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    },
    meals: [{
        id: {
            type: String,
            required: true
        },
        name: {
            type: String,
            required: true
        },
        description: {
            type: String,
            default: ''
        },
        imageUrl: {
            type: String,
            default: ''
        },
        calories: {
            type: Number,
            default: 0
        },
        ingredients: {
            type: [String],
            default: []
        }
    }]
});

module.exports = mongoose.model('Meal', mealSchema);
