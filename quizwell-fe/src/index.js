import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import reportWebVitals from './reportWebVitals';
import { createBrowserRouter, RouterProvider } from 'react-router-dom';

import App from './App';
import LandingPage from './routes/LandingPage/LandingPage';
import ShowQuiz from './routes/quiz/Show';

const router = createBrowserRouter([
  { path: '/', element: <LandingPage /> },
  { path: '/app', element: <App /> },
  { path: '/quiz/:uuid', element: <ShowQuiz />},
  { path: '/test', element: <div>Test</div> },
]);

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
