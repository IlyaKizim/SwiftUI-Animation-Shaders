//
//  Render.swift
//  SwiftUI Animation+Shaders
//
//  Created by Кизим Илья on 29.03.2024.
//

import Metal
import MetalKit

class Renderer: NSObject, MTKViewDelegate, ObservableObject{
    
    var view: MTKView!
    let device: MTLDevice
    let queue: MTLCommandQueue
    let cps: MTLComputePipelineState
    var texture: MTLTexture
    var timer: Float = 0
    var timerBuffer: MTLBuffer
    var time = TimeInterval(0.0)
    var speed: Float = 0.0
    var speedBuffer: MTLBuffer
    var intense: Float = 700
    var intenseBuffer: MTLBuffer
    
    init?(mtkView: MTKView){
        view = mtkView
        view.framebufferOnly = false
        
        if let defaultDevice = MTLCreateSystemDefaultDevice() {
            device = defaultDevice
        } else {
            print("Metal is not supported")
            return nil
        }
        
        queue = device.makeCommandQueue()!
        
        do {
            cps = try Renderer.buildComputePipelineState(device, view: mtkView)
        }
        catch {
            print("Unable to compile render pipeline state")
            return nil
        }
        
        do {
            texture = try Renderer.buildTexture(name: "photo", device)
        }
        catch {
            print("Unable to load texture from main bundle")
            return nil
        }
        
        timerBuffer = device.makeBuffer(length: MemoryLayout<Float>.size, options: [])!
        speedBuffer = device.makeBuffer(length: MemoryLayout<Float>.size, options: [])!
        intenseBuffer = device.makeBuffer(length: MemoryLayout<Float>.size, options: [])!
        
        super.init()
        view.delegate = self
        view.device = device
    }
    
    class func buildComputePipelineState(_ device:MTLDevice, view: MTKView) throws -> MTLComputePipelineState {
        let library = device.makeDefaultLibrary()!
        let kernal = library.makeFunction(name: "compute")!
        return try device.makeComputePipelineState(function: kernal)
    }
    
    class func buildTexture(name: String, _ device: MTLDevice) throws -> MTLTexture {
        let textureLoader = MTKTextureLoader(device: device)
        let path = Bundle.main.path(forResource: "photo", ofType: "jpg")
        
        guard let imagePath = path, let url = URL(string: "file://\(imagePath)") else {
            throw NSError(domain: "YourAppDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to get texture image path"])
        }
        let options: [MTKTextureLoader.Option: Any] = [
            .SRGB: false,
            .origin: MTKTextureLoader.Origin.bottomLeft
        ]
        return try textureLoader.newTexture(URL: url, options: options)
    }
    
    func updateWithTimestep(_ timestep: TimeInterval) {
        time = time + timestep
        timer = Float(time)
        let bufferPointer = timerBuffer.contents()
        memcpy(bufferPointer, &timer, MemoryLayout<Float>.size)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in metalView: MTKView) {
        if let drawable = view.currentDrawable{
            
            let commandBuffer = queue.makeCommandBuffer()
            let commandEncoder = commandBuffer?.makeComputeCommandEncoder()
            commandEncoder?.setComputePipelineState(cps)
            metalView.framebufferOnly = false
            commandEncoder?.setTexture(drawable.texture, index: 0)
            commandEncoder?.setTexture(texture, index: 1)
            commandEncoder?.setBuffer(timerBuffer, offset: 0, index: 0)
            
            let timestep = 1.0 / TimeInterval(view.preferredFramesPerSecond)
            updateWithTimestep(timestep)
            
            commandEncoder?.setBuffer(speedBuffer, offset: 0, index: 1)
            commandEncoder?.setBytes(&speed, length: MemoryLayout<Float>.size, index: 1)
            
            commandEncoder?.setBuffer(intenseBuffer, offset: 0, index: 2)
            commandEncoder?.setBytes(&intense, length: MemoryLayout<Float>.size, index: 2)
            
            let threadGroupCount = MTLSizeMake(8, 8, 1)
            let threadGroups = MTLSizeMake(drawable.texture.width / threadGroupCount.width, drawable.texture.height / threadGroupCount.height, 1)
            commandEncoder?.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
            commandEncoder?.endEncoding()
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
        }
    }
    
    public func changeTexture(imageURL: URL) {
        let textureLoader = MTKTextureLoader(device: device)
        
        do {
            let options: [MTKTextureLoader.Option: Any] = [
                .SRGB: false,
                .origin: MTKTextureLoader.Origin.bottomLeft
            ]
            
            texture = try textureLoader.newTexture(URL: imageURL, options: options)
        } catch {
            print("Error loading texture: \(error)")
        }
    }
    
    public func changeSpeed(speedVal: Float){
        speed = speedVal
    }
    
    public func changeIntense(intenseVal: Float){
        intense = intenseVal
    }
}
