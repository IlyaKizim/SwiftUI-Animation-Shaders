# SwiftUI-Animation-Shaders


🚀 Awesome Animation Concepts

RainEffect 💦:  The effect of flowing drops using MetalSL on textures

FrostEffect 🧊❄️: The effect of freezing and defrosting the screen by moving the ball

WaterRippleEffect 🌊: The effect of waves using MetalKit and Metal

PlayerCircleShadow 🔊🟢: Sound visualization

CustomLayoutWatch ⌚🕘: CustomLayout turning cubes into clocks with cool animations

PixelNumber 👾: Pixel numbers that break when colliding with waves

BacgroundAndSound 🖼️🌊: Simple and cool background with sound control

<div>
  <h2>RainEffect</h2>
  <video src="https://github.com/IlyaKizim/SwiftUI-Animation-Shaders/assets/122359658/0ad77241-e40a-4fd5-9371-83372a3b5f01" controls></video>
  <p>Create file <code>Metal</code> this funtction return <code>half4</code>
  <pre><code>
    [[ stitchable ]] half4 rainFall(float2 pos, float4 boundingRect, float iTime, texture2d<half> image)
  </code></pre>

  <p> If tou return  <code>half4</code> in Metal file you can use simple solution <code>foregroundStyle</code>, don`t forget use <code>TimelineView</code> to animate rain </p>
  <pre><code>
   TimelineView(.animation) {timeline in
                Rectangle()
                    .foregroundStyle(
                        ShaderLibrary.rainFall(
                            .boundingRect,
                            .float(timeline.date.timeIntervalSince(date)),
                            .image(Image("road"))
                        )
                    )
    }
  </code></pre>
  <p><a href="https://github.com/IlyaKizim/SwiftUI-Animation-Shaders/blob/main/SwiftUI%20Animation%2BShaders/RainAndFrost/RainAndFrost.swift" target="_blank">View the code</a> </p>
</div>

<div>
  <h2>FrostEffect</h2>
  <video src="https://github.com/IlyaKizim/SwiftUI-Animation-Shaders/assets/122359658/7c706b7e-a551-4b40-ba11-7e52dad4a55f" controls></video>
  <p> Function returning the same <code>half4</code> </p>
  <pre><code>
    [[stitchable]] half4 frost(float2 pos, float4 boundingRect, texture2d<half> image, float radius)
  </code></pre>

  <p> This time we change the <code>radius</code> depending on the shift of the ball </p>
  <pre><code>
   TimelineView(.animation) {timeline in
                Rectangle()
                    .foregroundStyle(
                        ShaderLibrary.frost(
                            .boundingRect,
                            .image(Image("road")),
                            .float(max(abs(dragOffset.width), abs(dragOffset.height)) * 0.009 + 1)
                        )
                    )
    }
  </code></pre>
  <p><a href="https://github.com/IlyaKizim/SwiftUI-Animation-Shaders/blob/main/SwiftUI%20Animation%2BShaders/RainAndFrost/RainAndFrost.swift" target="_blank">View the code</a> </p>
</div>

<div>
  <h2>WaterRippleEffect</h2>
  <video src="https://github.com/IlyaKizim/SwiftUI-Animation-Shaders/assets/122359658/5a1a494c-27c3-4986-b8f9-3df2ba8eec6c" controls></video>
  <p> Using <code>Metal</code> and <code>MetalKit</code> we can create <code>Renderer</code></p>
  <pre><code>
    import Metal
    import MetalKit
    class Renderer: NSObject, MTKViewDelegate, ObservableObject{
    var view: MTKView!
    }
  </code></pre>
  <p> Using <code>UIViewRepresentable</code> we can display the view in SwiftUI</p>
  <pre><code>
  struct MetalView: UIViewRepresentable {
    var renderer: Renderer?
    init(renderer: Renderer?) {
        self.renderer = renderer
    }  
    func makeUIView(context: Context) -> MTKView {
        guard let renderer = renderer else {
            return MTKView(frame: .zero)
        }
        return renderer.view
    }
    func updateUIView(_ uiView: MTKView, context: Context) {
    }
}
  </code></pre>
  <p><a href="https://github.com/IlyaKizim/SwiftUI-Animation-Shaders/blob/main/SwiftUI%20Animation%2BShaders/WaterRippleEffect/Wave.swift" target="_blank">View the code</a></p>
</div>

<div>
  <h2>PlayerCircleShadow</h2>
  <video src="https://github.com/IlyaKizim/SwiftUI-Animation-Shaders/assets/122359658/8ed3b6b7-2f60-4de1-9005-52698391052e" controls></video>
  <p> To get the empty <code>Circle()</code> use <code>.stroke</code> </p>
  <pre><code>
    Circle()
            .trim(from: 0, to: 1)
            .stroke(style: StrokeStyle(lineWidth: lineWidth))
            .frame(width: width)
  </code></pre>
  <p>We have simple <code>Shader</code></p>
  <pre><code>
  [[ stitchable ]] float2 waveCircle(float2 position, float time, float speed, float smoothing, float strength) {
    position.y += sin(time * speed + position.x / smoothing) * strength;
    return position;
  }
  </code></pre>
  <p>This <code>Shader</code> return the position, so we need to use <code>.distortionEffect()</code> </p> and don`t forget use <code>TimelineView</code> to animate wave </p>
  <pre><code>
            .distortionEffect(
                ShaderLibrary.waveCircle(
                    .float(time),
                    .float(speed),
                    .float(smoothing),
                    .float(strength)
                ),
                maxSampleOffset: CGSize(width: 200, height: 200)
            )
  </code></pre>
  <p><a href="https://github.com/IlyaKizim/SwiftUI-Animation-Shaders/blob/main/SwiftUI%20Animation%2BShaders/AudioPlayer/CircleShadow.swift" target="_blank">View the code</a></p>
</div>

<div>
  <h2>CustomLayoutWatch</h2>
  <video src="https://github.com/IlyaKizim/SwiftUI-Animation-Shaders/assets/122359658/59b025c8-6581-4cc0-bdfc-d4d4600e1cfe" controls></video>
  <p>If you want to do <code>CustomLayout</code> you need to implement two function </p>
  <pre><code>
    struct CustomLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {}
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {}
  </code></pre>
  <p> Now you can use your <code>CustomLayout</code> </p>
  <pre><code>
    @State private var layout: AnyLayout = AnyLayout(HStackLayout())
    ZStack {
            layout {
                ForEach(0..<12) {index in
                }
            }
  case 1: layout = AnyLayout(VerticleLayout())
  case 2: layout = AnyLayout(CircleLayout())
  case 3: layout = AnyLayout(HStackLayout())
  </code></pre>
 <p><a href="https://github.com/IlyaKizim/SwiftUI-Animation-Shaders/blob/main/SwiftUI%20Animation%2BShaders/CustomLayout/WatchAnimation.swift">View the code</a></p>
</div>

<div>
  <h2>PixelNumber</h2>
  <video src="https://github.com/IlyaKizim/SwiftUI-Animation-Shaders/assets/122359658/acf63bb2-a145-4a1f-ba10-57ca9e1b6daf" controls></video>
  <p> We have simple <code>Shader</code> returnung coords </p>
  <pre><code>
    [[ stitchable ]] float2 pixel(float2 position, float strength) {
    float min_strength = max(strength, 0.0001);
    float coord_x = min_strength * round(position.x / min_strength);
    float coord_y = min_strength * round(position.y / min_strength);
    return float2(coord_x, coord_y);
  }
  </code></pre>
  <p> Use <code>.distortionEffect()</code>. This time we don`t need use <code>TimeLine</code> because we don`t need animate It </p>
  <pre><code>
    .distortionEffect(
        ShaderLibrary.pixel(
       .float(array[number - 1] ? 7 : 3)
      ), maxSampleOffset: .zero)
  </code></pre>
  <p><a href="https://github.com/IlyaKizim/SwiftUI-Animation-Shaders/blob/main/SwiftUI%20Animation%2BShaders/PixelateNumber/PixelNumberScroll.swift">View the code</a></p>
</div>

<div>
  <h2>BacgroundAndSound</h2>
  <video src="https://github.com/IlyaKizim/SwiftUI-Animation-Shaders/assets/122359658/59f9efb5-c67a-48b7-ad38-7be3c590f308" controls></video>
  <p> Simple and cool <code>Background</code> .</p>
  <pre><code>
    LinearGradient(colors: [.cyan, .mint], startPoint: .leading, endPoint: .trailing)
                        .frame(width: UIScreen.main.bounds.width + 120, height: UIScreen.main.bounds.height / 3)
                        .rotationEffect(Angle.degrees(15))
                        .waveShader(WaveConfiguration(time: time, speed: -5, frequency: 100, amplitude: 20))
                        .offset(y: 100)
  </code></pre>
  <p><a href="https://github.com/IlyaKizim/SwiftUI-Animation-Shaders/blob/main/SwiftUI%20Animation%2BShaders/BackgroundAndSound/BackgroundAndSound.swift">View the code</a></p>
</div>

<div>
  <h2>Thank You for Watching!</h2>
</div>


