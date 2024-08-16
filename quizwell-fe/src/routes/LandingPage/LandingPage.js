import React from 'react';
import { useNavigate } from 'react-router-dom';
import './LandingPage.css';
import GenerateQuizDemo from '../../images/GenerateQuizDemo.JPG';
import QuizzesListDemo from '../../images/QuizzesListDemo.JPG';

function LandingPage() {
  const navigate = useNavigate();

  return (
    <div className="landing-page">
      <nav className="navbar navbar-expand-lg navbar-dark bg-dark fixed-top" id="mainNav">
        <div className="container px-4">
          <a className="navbar-brand" href="#page-top">QuizWell</a>
          <button className="navbar-toggler" type="button" data-bs-toggle="collapse" 
          data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" 
          aria-label="Toggle navigation"><span className="navbar-toggler-icon"></span></button>
          <div className="navbar-collapse collapse" id="navbarResponsive">
            <ul className="navbar-nav ms-auto">
              <li className="nav-item"><a className="nav-link" href="#what">About</a></li>
              <li className="nav-item"><a className="nav-link" href="#how">How it works</a></li>
              <li className="nav-item"><a className="nav-link" href="#info">How to use</a></li>
            </ul>
          </div>
        </div>
      </nav>
      <header className="bg-primary bg-gradient text-white" id="page-top">
        <div className="container px-4 text-center">
          <h1 className="fw-bolder">Welcome to QuizWell</h1>
          <p className="lead">Your go-to platform to prepare for technical interviews</p>
          <button className="btn btn-lg btn-light" onClick={() => navigate('/app')}>
            Get Started
          </button>
        </div>
      </header>
      <section className="features" id="what">
        <h2>What is QuizWell?</h2>
        <p className="lead">
          QuizWell is the place where you can generate your own customized quizzes based 
          on job descriptions or select from a list of available quizzes. 
          Practice and improve your skills to perform better at the 
          technical interviews.
        </p>
      </section>
      <section className="features" id="how">
        <h2>How does it work?</h2>
        <p className="lead">
          You can choose to take a technical quiz one of two ways: based on a job description 
          you provide, the app can generate a personalized technical quiz for you or you can 
          choose an existing one from the displayed list of available quizzes. You can filter 
          the quizzes based on specific tags such as technologies and frameworks you 
          are interested in.
        </p>
      </section>
      <div className="row mb-2" id="info">
        <div className="col-md-6">
          <div className="card-image-bottom mb-4 box-shadow h-md-250" id="cardInfo">
            <div className="card-body d-flex flex-column align-items-start">
              <h3 className="mb-0" id="titleInfo">Generate a quiz</h3>
              <p className="card-text mb-auto" id="infoText">
                To generate a personalized quiz, input a job description including the targeted 
                technologies and frameworks, preferably more than one. Based on the information 
                you provide, the app will generate a quiz for you.
              </p>
            </div>
            <img className="card-img-bottom flex-auto d-none d-md-block" 
            src={GenerateQuizDemo} alt="Generate Quiz Demo"/>
          </div>
        </div>
        <div className="col-md-6">
          <div className="card-image-bottom mb-4 box-shadow h-md-250" id="cardInfo">
            <div className="card-body d-flex flex-column align-items-start">
              <h3 className="mb-0" id="titleInfo">Or choose a quiz from the list</h3>
              <p className="card-text mb-auto" id="infoText">
                You can also choose to take an available quiz from the displayed list. You have 
                the option to filter the displayed quizzes based on tags that interest you.
              </p>
            </div>
            <img className="card-img-bottom flex-auto d-none d-md-block" 
            src={QuizzesListDemo} alt="Quizzes List Demo"/>
          </div>
        </div>
      </div>
      <footer className="py-5 bg-dark">
        <div className="container px-4">
          <p className="m-0 text-center text-white">
            © 2024 QuizWell. All rights reserved.
          </p>
        </div>
      </footer>
    </div>
  );
}

export default LandingPage;