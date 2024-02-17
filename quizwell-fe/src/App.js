import { useState } from 'react';
import './App.css';

// import bootstrap
import 'bootstrap/dist/css/bootstrap.min.css';

function App() {
  const [jobDescription, setJobDescription] = useState('');

  function generateQuiz() {
    fetch('/api/quiz/generate', { 
      method: 'POST', 
      body: JSON.stringify({ jobDescription: jobDescription }) }
    ).then(response => response.json())
    .then(data => {
      console.log(data);
    });
  }

  return (
    <div>
      <main className="container">
        <h1>Quizwell</h1>
        <div className="mb-3">
          <label for="jobDescription" className="form-label">
            Job description
          </label>
          <textarea className="form-control" id="jobDescription" rows="10"
            onChange={ (e) => setJobDescription(e.target.value) }/>
        </div>
        <button className="btn btn-primary" onClick={generateQuiz}>Generate</button>
      </main>
    </div>
  );
}

export default App;
