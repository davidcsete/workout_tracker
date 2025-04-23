# Workout Tracker

## Overview

This is a workout tracker application built with **Ruby on Rails**. The app allows users to create workout plans, track exercises, and log their progress in real-time. The app is designed to help individuals manage their fitness journey by providing a platform to record and monitor their exercise activities.

### Key Features
- **Workout Plans:** Users can create and manage their workout plans.
- **Exercise Tracking:** Track exercises with real-time updates on reps, sets, and weights.
- **Real-Time Updates:** Exercise progress is reflected in real-time using Turbo Streams.
- **Admin Dashboard:** Admins can manage users and monitor their progress.
- **User Authentication:** Secure login using Devise for user authentication.
- **Responsive UI:** Built with TailwindCSS and Hotwire for seamless interactions.
- **Llama2 AI Chatbot**: Interact with an integrated Llama2 AI chatbot for personalized fitness advice, exercise suggestions, and motivation.


## Technologies Used

- **Ruby on Rails (v8)**: Backend framework
- **PostgreSQL**: Database for storing workout and user data
- **TailwindCSS**: For styling and responsive design
- **Hotwire**: For real-time updates (Turbo Streams)
- **Devise**: For user authentication
- **Docker**: Containerization for deployment
- **Kamal**: For deployment to the cloud

## Setup Instructions

### Prerequisites

- **Ruby 3.0+**
- **Rails 8**
- **PostgreSQL** (make sure you have PostgreSQL installed and running)
- **Docker** (if you prefer to run the app in a container)

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/workout-tracker.git
cd workout-tracker
```
### 2. Install dependencies

Run the following command to install the necessary dependencies:

```bash
bundle install
```
### 3. Set up the database
```bash
rails db:create
rails db:migrate
rails db:seed
```
## the seed command will populate the database with sample workout plans, exercises, and tracking data.

### 4. Start the Rails server
```bash
Copy
Edit
rails server
```
### 5. Dockerize (Optional)

If you prefer using Docker to run the app, you can follow these steps:

#### Build the Docker image

```bash
docker-compose build
```

## Run the app in a container
```bash
docker-compose up
```
You can access the app at http://localhost:3000.