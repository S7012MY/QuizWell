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
Designed to assist job seekers in preparing for interviews, this application offers various tests tailored to different job positions. By inputting the desired position, candidates can access relevant practice questions, streamlining their preparation process and increasing their chances of success during interviews.


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

* For macOS system: Perl 5.38.2 Perlbrew --> https://perlbrew.pl 
* For Windows system: 
  1. Set up a Windows Subsystem for Linux (WSL) --> https://learn.microsoft.com/en-us/windows/wsl/install 
     > [!NOTE] On the left side, there are available tutorials you can use.
  2. Update and upgrade packages with this command: `sudo apt update && sudo apt upgrade`
  3. Get started with Git --> https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-git 
     > [!Useful]
     - Connecting to GitHub with SSH --> https://docs.github.com/en/authentication/connecting-to-github-with-ssh
     - Sharing SSH keys between Windows and WSL --> https://devblogs.microsoft.com/commandline/sharing-ssh-keys-between-windows-and-wsl-2/#:~:text=You%20can%20setup%20SSH%20keys,keys%20just%20live%20in%20it. 
  4. Get started with VS Code --> https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-vscode 
  5. Install Perlbrew --> https://perlbrew.pl/Installation.html
     > [!NOTE] After installation, follow the instructions in the terminal: Append the following piece of code to the end of your `~/.profile` (or `~/.bashrc`), in order to switch to perlbrew automatically each time you open a new terminal: `source ~/perl5/perlbrew/etc/bashrc` 
     > Update to `perl-5.36.1` with these commands:
       `perlbrew install perl-5.36.1`
       `perlbrew switch perl-5.36.1`
  6. Create the files where errors and warnings from the backend will get logged/saved by running these 2 commands in a new terminal: 
   `sudo touch /var/log/quizwell.log`
   `sudo chmod 777 /var/log/quizwell.log`

#### Installation Steps

1. Clone the Repository: Clone the project repository from GitHub:
    `git clone https://github.com/S7012MY/QuizWell.git`
2. Navigate to the Backend Directory: Change your current directory to the backend folder:
    `cd QuizWell/quizwell-be/quiz_well`
3. Install Dependencies: Install the required Perl dependencies using CPANM:
   * macOS system --> install Homebrew:  
    `cpanm Carton`
    `carton install`
   * Windows system: 
     - install carton: https://howtoinstall.co/package/carton  
     - install packages: `carton install`

4. Connect to the database:
   - Open Terminal: Open your terminal or command prompt.
   - Access PostgreSQL: 
     * macOS system -->
        `brew install postgresql`
        `psql`
     * Windows system --> Install PostgreSQL https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-database 
        !create a database with your username (in `psql`): `createdb <<username>>`, then create role superuser: 
        `sudo -u postgres createuser -s -i -d -r -l -w <<username>>`
   - Create Database: Once logged in, you can create a new database using the CREATE DATABASE command:
     * macOS system --> `CREATE DATABASE quizwell`
     * Windows system --> `createdb quizwell`
   - Exit PostgreSQL: After creating the database and granting privileges, you can exit the PostgreSQL prompt by typing:
    `\q`
   - Being located in the script file `~/QuizWell/quizwell-be/quiz_well/script` run this command: 
     `PGDATABASE=quizwell carton exec -- perl deploy_schema.pl`

5. Open VS Code in QuizWell folder and in `quizwell-be > quiz_well` create a file named `quiz_well.conf` and paste this code inside and save it:

```
{
  openai_key => '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',
  secrets => ['asdsadasdsad'],
  hypnotoad => {
    listen => ['http://127.0.0.1:8086']
  }
}
```

6. Start the backend application:
   * macOS system: Being located in the 'script' folder run this command:
    `carton exec -- perl quiz_well daemon -l http://127.0.0.1:8086`
   * Windows system: Navigate to `~/QuizWell/quizwell-be/quiz_well` and run this command: 
        `PGDATABASE=quizwell carton exec -- morbo script/quiz_well -l http://127.0.0.1:8086`

### Frontend Installation
1. Navigate to the Frontend Directory: Change your current directory to the frontend folder:
    `cd ~/QuizWell/quizwell-fe`
2. Install dependencies:
   * macOS system: `npm install`
   * Windows system: 
     - `sudo apt install npm`
     - upgrade to Node 20+ by running these commands: 
       >`sudo npm cache clean -f`
       >`sudo npm install -g n`
       >`sudo n stable`
       >`npm install`
3. Open a new terminal, navigate to `cd ~/QuizWell/quizwell-fe` again, and start the application::
`npm start`

## Usage


## Contributing
Guidelines for contributing to the project. Include information on how to report bugs, suggest enhancements, and submit pull requests.

### Pull Request Process
 
1. Create a new branch (`git checkout -b yourInitials/new-feature`)
2. Make your changes and commit them (`git commit -am 'Add new feature'`)
3. Push your changes to the branch (`git push origin feature/new-feature`)
4. Open a pull request.
>Note: In the description of the repository you can add pictures of the components (if you're implementing someting on the frontend) or a short description of the feature.


## License 
This project is lincensed under the Copyright WellCode 2024.

