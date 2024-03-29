# SwiftUI-Animation-Shaders


🚀 Awesome Animation Concepts

Slider 🎡: Personalized slider featuring images gracefully dispersing in various directions.

Gravity 🌌: Animated Xcode ascending a pedestal, triumphing over buildFailed challenges.

Thunder + Rain ⚡: Simulated rain and thunder effects.

DrawHearts 💖: Endearing depiction of a hand-drawn heart.

GradientButton 🌟: Smooth color transitions within the shape.

Exclusively crafted using UIKit; no additional frameworks needed. Enjoy the showcase! 🎉✨

<div>
  <h2>BacgroundAndSound</h2>
 <video src="https://github.com/IlyaKizim/SwiftUI-Animation-Shaders/assets/122359658/59f9efb5-c67a-48b7-ad38-7be3c590f308" controls></video>
  <p><a href="https://github.com/IlyaKizim/UIKit-Animations/tree/main/UIKit-Animations/Slider" target="_blank">View the code</a></p>
</div>

<div>
  <h2>Slider</h2>
  <video src="https://github.com/IlyaKizim/UIKit-Animations/assets/122359658/8e799a8b-5346-485f-a242-3df50d48503f" controls></video>
  <p><a href="https://github.com/IlyaKizim/UIKit-Animations/tree/main/UIKit-Animations/Slider" target="_blank">View the code</a></p>
</div>

<div>
  <h2>Gravity</h2>
  <video src="https://github.com/IlyaKizim/UIKit-Animations/assets/122359658/87522193-8b7c-46e3-9f5a-3cf60006ac52" controls></video>
  <pre><code>
    private var animator: UIDynamicAnimator?
    private var behavior: UICollisionBehavior?
  </code></pre>
  <p>Use <code>UIDynamicAnimator</code> and <code>UICollisionBehavior</code> for dynamic animations and collision handling.</p>
  <p><a href="https://github.com/IlyaKizim/UIKit-Animations/tree/main/UIKit-Animations/GravityXcode" target="_blank">View the code</a></p>
</div>

<div>
  <h2>TableView</h2>
  <video src="https://github.com/IlyaKizim/UIKit-Animations/assets/122359658/0d67e73b-125f-4de0-b6df-457cd7f3d921" controls></video>
   <p>Use <code>CAEmitterCell</code> and <code>CAEmitterLayer</code> to create animated particles.</p>
  <pre><code>
    let emitterLayer = CAEmitterLayer()
    let cell = CAEmitterCell()
  </code></pre>
  <p><a href="https://github.com/IlyaKizim/UIKit-Animations/tree/main/UIKit-Animations/TableView" target="_blank">View the code</a></p>
</div>


<div>
  <h2>Thunder+Rain</h2>
  <video src="https://github.com/IlyaKizim/UIKit-Animations/assets/122359658/c0b8a88c-3583-4688-9aa9-e7426c49d38e" controls></video>
  <p>The part of code:</p>
  <pre><code>
    private var thunderstormLayer = CAEmitterLayer()
    private var rainCell = CAEmitterCell()
    private var lightningCell = CAEmitterCell()
    private var lightningLayer = CAEmitterLayer()
    // Configure rain emitter cell properties
    rainCell.birthRate = 150
    rainCell.lifetime = 6
    rainCell.velocity = 500
    rainCell.velocityRange = 50
    rainCell.emissionLongitude = .pi
    rainCell.emissionRange = .pi / 10
    rainCell.spin = 1.5
    rainCell.spinRange = 0.9
    rainCell.scale = 0.005
    rainCell.scaleRange = 0.05
    rainCell.contents = UIImage(named: Constant.particles)?.cgImage
  </code></pre>
  <p><a href="https://github.com/IlyaKizim/UIKit-Animations/tree/main/UIKit-Animations/RainAndThunder" target="_blank">View the code</a></p>
</div>


<div>
  <h2>DrawHearts</h2>
  <video src="https://github.com/IlyaKizim/UIKit-Animations/assets/122359658/32a75ac0-80d6-40ee-94d1-cc1e9647979d" controls></video>
  <p>Use <code>UIBezierPath</code> and <code>CABasicAnimation</code> to draw and animate it</p>
  <pre><code>
  let path = UIBezierPath()
  let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
  </code></pre>
  <p><a href="https://github.com/IlyaKizim/UIKit-Animations/tree/main/UIKit-Animations/DrawHearts" target="_blank">View the code</a></p>
</div>


<div>
  <h2>GradientButton</h2>
  <video src="https://github.com/IlyaKizim/UIKit-Animations/assets/122359658/52c76f2d-5ab3-4080-93c0-1e33582dbc07" controls></video>
  <p>Use <code>CAKeyframeAnimation</code> and <code>CABasicAnimation</code> to animate shadow and changing color </p>
  <pre><code>
    let colorAnimation = CAKeyframeAnimation(keyPath: "shadowColor")
    let gradientAnimation = CABasicAnimation(keyPath: "colors")
  </code></pre>
  <p><a href="https://github.com/IlyaKizim/UIKit-Animations/tree/main/UIKit-Animations/GradientButton" target="_blank">View the codes</a></p>
</div>

<div>
  <h2>Thank You for Watching!</h2>
</div>


