import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './App.css';

// import bootstrap
import 'bootstrap/dist/css/bootstrap.min.css';

function App() {
  const navigate = useNavigate();
  const [jobDescription, setJobDescription] = useState('');

  function generateQuiz() {
    fetch('/api/quiz/generate', { 
      method: 'POST', 
      body: JSON.stringify({ jobDescription: jobDescription }) }
    ).then(response => response.json())
    .then(data => {
      if (!data.error) {
        navigate(`/quiz/${data.uuid}`);
      }
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
