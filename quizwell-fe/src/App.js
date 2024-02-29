import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './App.css';

// import bootstrap
import 'bootstrap/dist/css/bootstrap.min.css';

function App() {
  const navigate = useNavigate();
  const [jobDescription, setJobDescription] = useState('');
  const [isGenerating, setIsGenerating] = useState(false);

  function generateQuiz() {
    setIsGenerating(true);
    fetch('/api/quiz/generate', { 
      method: 'POST', 
      body: JSON.stringify({ jobDescription: jobDescription }) }
    ).then(response => response.json())
    .then(data => {
      if (!data.error) {
        navigate(`/quiz/${data.uuid}`);
      } else {
        console.error(data.error);
        alert("Generating quiz failed. Try again with a slightly different " 
          + "job description");
        alert(data.error);
        setIsGenerating(false);
      }
    });
  }

  return (
    <div>
      <main className="container">
        <h1>Quizwell</h1>
        <div className="mb-3">
          <label for="jobDescription" className="form-label">
            Paste the job description below and we will generate a quiz for you
          </label>
          <textarea className="form-control" id="jobDescription" rows="10"
            onChange={ (e) => setJobDescription(e.target.value) }/>
        </div>
        {!isGenerating && <button className="btn btn-primary" onClick={generateQuiz}>Generate</button>}
        {isGenerating && <div>Generating...</div>}
      </main>
    </div>
  );
}

export default App;
