# Meal Planning Application

A full-stack mobile application for managing daily meal plans with a modern, intuitive interface.

## 🚀 Features

- Drag-and-drop meal management
- Daily meal organization
- Image caching for fast loading
- Responsive and fluid UI
- Cross-platform support

## 🛠️ Tech Stack

### Frontend
- Flutter
- Provider for state management
- HTTP for API communication
- Flutter dotenv for environment management
- Custom image caching solution

### Backend
- Express.js
- MongoDB for database
- RESTful API architecture

## 📦 Installation

### Prerequisites
- Flutter SDK
- Node.js
- MongoDB
- Git

### Setting up the Backend

1. Navigate to the backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Create a `.env` file in the backend directory with:
```
PORT=3000
MONGODB_URI=your_mongodb_uri
```

4. Start the server:
```bash
npm start
```

### Setting up the Frontend

1. Navigate to the frontend directory:
```bash
cd frontend
```

2. Install Flutter dependencies:
```bash
flutter pub get
```

3. Create a `.env` file in the frontend directory with:
```
API_BASE_URL=http://your_backend_url:3000/api
```

4. Run the app:
```bash
flutter run
```

## 🌐 API Endpoints

### Get All Meals
```http
GET /api/meals
```
Returns all meals organized by days.

#### Response
```json
{
  "monday": [
    {
      "id": "meal_id",
      "name": "Meal Name",
      "description": "Meal Description",
      "calories": 500,
      "imageUrl": "http://example.com/image.jpg",
      "ingredients": ["ingredient1", "ingredient2"]
    }
  ],
  "tuesday": [...],
  // ... other days
}
```

### Move Meal Between Days
```http
PUT /api/move
```
Moves a meal from one day to another.

#### Request Body
```json
{
  "sourceDay": "monday",
  "targetDay": "tuesday",
  "mealId": "meal_id"
}
```

#### Response
```json
{
  "success": true,
  "message": "Meal moved successfully"
}
```

#### Error Response
```json
{
  "success": false,
  "error": "Error message"
}
```

### Status Codes
- 200: Success
- 400: Bad Request
- 404: Not Found
- 500: Server Error

## 🔒 Environment Variables

### Backend
- `PORT`: Server port (default: 3000)
- `MONGODB_URI`: MongoDB connection string

### Frontend
- `API_BASE_URL`: Backend API base URL

## 📱 App Structure

```
meal_plan/
├── frontend/           # Flutter application
│   ├── lib/
│   │   ├── config/    # Configuration files
│   │   ├── models/    # Data models
│   │   ├── providers/ # State management
│   │   ├── screens/   # UI screens
│   │   ├── services/  # API services
│   │   └── widgets/   # Reusable widgets
│   └── ...
└── backend/           # Express.js server
    ├── routes/        # API routes
    ├── models/        # Database models
    ├── controllers/   # Business logic
    └── ...
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Express.js community
- MongoDB team

## 📫 Contact

Your Name - your.email@example.com
Project Link: [https://github.com/shrey258/meal_plan](https://github.com/shrey258/meal_plan)
