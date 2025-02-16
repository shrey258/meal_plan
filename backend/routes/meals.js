const express = require('express');
const router = express.Router();
const Meal = require('../models/meal');
const { v4: uuidv4 } = require('uuid');

// Hardcoded meals data
const mealsData = [
  {
    day: 'Monday',
    meals: [
      {
        id: uuidv4(),
        name: 'Greek Yogurt Parfait',
        description: 'Creamy Greek yogurt layered with fresh berries and honey granola',
        imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?ixlib=rb-4.0.3',
        calories: 320,
        ingredients: ['Greek yogurt', 'Mixed berries', 'Honey', 'Granola'],
      },
      {
        id: uuidv4(),
        name: 'Mediterranean Quinoa Bowl',
        description: 'Fresh and healthy bowl with quinoa, chickpeas, and Mediterranean vegetables',
        imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3',
        calories: 450,
        ingredients: ['Quinoa', 'Chickpeas', 'Cucumber', 'Tomatoes', 'Feta cheese', 'Olive oil'],
      },
      {
        id: uuidv4(),
        name: 'Grilled Salmon',
        description: 'Fresh Atlantic salmon grilled to perfection with roasted vegetables',
        imageUrl: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?ixlib=rb-4.0.3',
        calories: 520,
        ingredients: ['Salmon', 'Asparagus', 'Sweet potatoes', 'Lemon', 'Herbs'],
      }
    ]
  },
  {
    day: 'Tuesday',
    meals: [
      {
        id: uuidv4(),
        name: 'Avocado Toast',
        description: 'Whole grain toast topped with mashed avocado, eggs, and cherry tomatoes',
        imageUrl: 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?ixlib=rb-4.0.3',
        calories: 380,
        ingredients: ['Whole grain bread', 'Avocado', 'Eggs', 'Cherry tomatoes', 'Red pepper flakes'],
      },
      {
        id: uuidv4(),
        name: 'Chicken Buddha Bowl',
        description: 'Nutritious bowl with grilled chicken, brown rice, and colorful vegetables',
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3',
        calories: 550,
        ingredients: ['Grilled chicken', 'Brown rice', 'Kale', 'Carrots', 'Edamame', 'Tahini sauce'],
      },
      {
        id: uuidv4(),
        name: 'Shrimp Stir Fry',
        description: 'Quick and healthy stir-fried shrimp with vegetables and brown rice',
        imageUrl: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?ixlib=rb-4.0.3',
        calories: 480,
        ingredients: ['Shrimp', 'Broccoli', 'Bell peppers', 'Brown rice', 'Soy sauce'],
      }
    ]
  },
  {
    day: 'Wednesday',
    meals: [
      {
        id: uuidv4(),
        name: 'Overnight Oats',
        description: 'Creamy overnight oats with chia seeds, almond milk, and fresh fruits',
        imageUrl: 'https://images.unsplash.com/photo-1516714435131-44d6b64dc6a2?ixlib=rb-4.0.3',
        calories: 340,
        ingredients: ['Oats', 'Chia seeds', 'Almond milk', 'Banana', 'Berries', 'Honey'],
      },
      {
        id: uuidv4(),
        name: 'Turkey Wrap',
        description: 'Whole wheat wrap filled with turkey, avocado, and fresh vegetables',
        imageUrl: 'https://images.unsplash.com/photo-1509722747041-616f39b57569?ixlib=rb-4.0.3',
        calories: 420,
        ingredients: ['Turkey breast', 'Whole wheat wrap', 'Avocado', 'Lettuce', 'Tomato'],
      },
      {
        id: uuidv4(),
        name: 'Vegetarian Curry',
        description: 'Aromatic vegetable curry with chickpeas served over brown rice',
        imageUrl: 'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?ixlib=rb-4.0.3',
        calories: 460,
        ingredients: ['Chickpeas', 'Mixed vegetables', 'Coconut milk', 'Curry spices', 'Brown rice'],
      }
    ]
  }
];

// Initialize database with hardcoded data
async function initializeDatabase() {
  try {
    // Clear existing data
    await Meal.deleteMany({});
    
    // Insert new data
    await Meal.insertMany(mealsData);
    console.log('Database initialized with sample data');
  } catch (error) {
    console.error('Error initializing database:', error);
  }
}

// Call initialization when the server starts
initializeDatabase();

// Get all meals
router.get('/', async (req, res) => {
  try {
    const meals = await Meal.find();
    res.json(meals);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Move a meal from one day to another
router.put('/move', async (req, res) => {
  try {
    const { sourceDay, mealId, targetDay } = req.body;
    console.log('Moving meal:', { sourceDay, mealId, targetDay });

    // Find the source and target days
    const sourceDayDoc = await Meal.findOne({ day: sourceDay });
    const targetDayDoc = await Meal.findOne({ day: targetDay });

    if (!sourceDayDoc || !targetDayDoc) {
      return res.status(404).json({ message: 'Day not found' });
    }

    // Find the meal to move
    const mealToMove = sourceDayDoc.meals.find(m => m.id === mealId);
    if (!mealToMove) {
      return res.status(404).json({ message: 'Meal not found' });
    }

    // Remove the meal from source day
    sourceDayDoc.meals = sourceDayDoc.meals.filter(m => m.id !== mealId);

    // Add the meal to target day
    targetDayDoc.meals.push(mealToMove);

    // Save both documents
    await sourceDayDoc.save();
    await targetDayDoc.save();

    res.json({ message: 'Meal moved successfully' });
  } catch (error) {
    console.error('Error moving meal:', error);
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
