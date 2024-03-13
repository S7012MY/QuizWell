# QuizWell 

Welcome to the installation guide for the backend and frontend parts of Quizwell. This guide will help you set up the necessary environment and dependencies to run both the backend and frontend on your local machine. 



## Table of Contents

- [Project Name](#QuizWell)
- [Table of Contents](#table-of-contents)
- [Description](#description)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)



## Description

As part of the WellCode Mentorship program, candidates are often required to undergo technical interviews where they are tested on their programming knowledge and problem-solving skills. This application aims to streamline the interview preparation process by providing candidates with tailored practice questions and constructive feedback.


### Features:

* Job Post Integration: The application integrates with job posts, extracting key requirements and generating relevant programming questions.
* Question Generation: Based on the job post, the application dynamically generates programming questions covering various topics such as algorithms, data structures, and programming languages.
* Answer Selection: Users can choose from multiple-choice answers for each question, simulating real interview scenarios.
* Feedback Generation: After completing the question set, users receive personalized feedback highlighting areas for improvement and suggesting subjects they should study more.
* User-Friendly Interface: The application features a simple and intuitive user interface, making it accessible to users of all skill levels.



## Installation

### Backend Installation

#### Prerequisites
Before proceeding with the installation, ensure that you have the following prerequisites installed on your system:

Perl 5.38.2
Perlbrew → https://perlbrew.pl
`cpanm Carton`

#### Installation Steps

1. Clone the Repository: Clone the project repository from GitHub:
    `git clone https://github.com/S7012MY/QuizWell.git`

2. Navigate to the Backend Directory: Change your current directory to the backend folder:
    `cd quizwell-be/quiz_well`

3. Install Dependencies: Install the required Perl dependencies using CPAN or any other package manager:
    install Homebrew
    `brew install carton`
    `carton install`

4. Connect to the database:

    - Open Terminal: Open your terminal or command prompt.

    - Access PostgreSQL: 
        `brew install postgresql`
        `psql`

    - Create Database: Once logged in, you can create a new database using the CREATE DATABASE command:
        `CREATE DATABASE quizwell`

    - Exit PostgreSQL: After creating the database and granting privileges, you can exit the PostgreSQL prompt by typing:
        `\q`

5. Start the backend application:
    `...`


### Frontend Installation

1. Navigate to the Frontend Directory: Change your current directory to the frontend folder:
    `cd quizwell-fe`

2. Install dependencies:
    `npm install`

3. Start the application:
    `npm start`



## Usage



## Contributing
Guidelines for contributing to the project. Include information on how to report bugs, suggest enhancements, and submit pull requests.

### Pull Request Process

1. Fork the repository
2. Create a new branch (`git checkout -b feature/new-feature`)
3. Make your changes and commit them (`git commit -am 'Add new feature'`)
4. Push your changes to the branch (`git push origin feature/new-feature`)
5. Open a pull request.



## License 
This project is lincensed under the ... 




