## ✅ Acceptance Criteria

The application should meet the following functional and technical acceptance criteria.

### 1. Character Listing

- [x] On launching the application, the app should fetch character data from the Rick and Morty REST API using the `/character` endpoint.
- [x] Display the first 20 characters on the listing screen.
- [x] Each character item should display:
  - Character thumbnail/image.
  - Character name.
  - Total number of episodes in which the character has appeared.
- [x] Character data should be displayed in a clean and user-friendly interface.
- [x] Handle API loading states and potential network errors gracefully.

### 2. Character Search

- [x] Users should be able to search for characters by name.
- [x] Search results should update based on the entered search query.
- [x] Search should support partial and case-insensitive character names.
- [x] Display an appropriate message when no matching characters are found.
- [x] Handle search API errors gracefully.

### 3. Character Details

- [x] Tapping on a character from the listing screen should navigate to its detail screen.
- [x] The detail screen should display the following information:
  - Character image.
  - Character name.
  - Status (Alive, Dead, or Unknown).
  - Species.
  - Gender.
  - Current location.
- [x] The displayed information should correspond to the selected character.

### 4. API Integration

- [x] Integrate with the official [Rick and Morty REST API](https://rickandmortyapi.com/).
- [x] Implement API communication using custom networking code.
- [x] Do not use any third-party Rick and Morty SDK.
- [x] Use appropriate HTTP methods and handle API responses.
- [x] Handle Api failure scenarios.

### 5. Technical Requirements

- [x] Implement the application using SwiftUI.
- [x] Follow a clean and maintainable code structure.
- [x] Separate networking, data handling, and presentation responsibilities.
- [x] Use appropriate error handling throughout the application.
- [x] Third-party libraries are permitted only for image caching.
- [x] Ensure the application remains responsive during API requests.

### 6. UI and User Experience

- [x] Provide a smooth navigation experience between the character listing and detail screens.
- [x] Display appropriate loading indicators while fetching data.
- [x] Handle empty states and error states with meaningful messages.
- [x] Ensure character images load efficiently and support image caching.

---

### 📸 Screenshots

The application screenshots demonstrating the character listing, search functionality, and character details are provided above.

### 🔗 API Reference

[Rick and Morty API Documentation](https://rickandmortyapi.com/documentation)


<img width="350" height="650" alt="LaunchScreen" src="https://github.com/user-attachments/assets/a68c6432-2df4-4982-ab38-5af02152969a" />
<img width="350" height="650" alt="CharacterListView" src="https://github.com/user-attachments/assets/56a66168-414e-490f-b0b3-5aee1070cb13" />
<img width="350" height="650" alt="SearchCharactersView" src="https://github.com/user-attachments/assets/1a6a0dc9-9935-43b6-a60d-20ea116e893a" />
<img width="350" height="650" alt="CharactersDetailsView" src="https://github.com/user-attachments/assets/643a430d-9a24-41a3-95e2-2d02bb99a74d" />

