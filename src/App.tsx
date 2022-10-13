import { useState } from 'react'
import reactLogo from './assets/react.svg'
import './App.css'

function App() {
  const [count, setCount] = useState(0)

  return (
    <div className="App">
      <div>
        <a href="https://vitejs.dev" target="_blank">
          <img src="/vite.svg" className="logo" alt="Vite logo" />
        </a>
        <a href="https://reactjs.org" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
        <a href="https://aws.amazon.com/s3/" target="_blank">
          <img src="/s3.svg" className="logo react" alt="S3 logo" />
        </a>
        <a href="https://aws.amazon.com/cloudfront/" target="_blank">
          <img src="/cloudfront.webp" className="logo react" alt="Cloudfront logo" />
        </a>
        <a href="https://www.terraform.io/" target="_blank">
          <img src="/tf.png" className="logo react" alt="Terraform logo" />
        </a>
      </div>
      <h1>Vite + React + S3 + Cloudfront + λ @ edge <br/> <hr/> via Terraform</h1>
      
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          Click Me:<br/><br/>
          Count is {count}
        </button>
      </div>
    </div>
  )
}

export default App
