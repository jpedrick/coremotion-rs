## CoreMotion-rs
Makes [CoreMotion](https://developer.apple.com/documentation/coremotion?language=objc) API available to Rust

### Basic Usage

Cargo.toml
```
[dependencies]
coremotion = { git = "https://github.com/jpedrick/coremotion-rs.git" }
```

Your code:
```
use coremotion::{CMMotionManager, ICMAccelerometerData, ICMMotionManager, INSObject};

fn sample_accelerometer() {
    let manager = CMMotionManager::alloc();
    unsafe {
        manager.init();
        let available = manager.isAccelerometerAvailable();
        println!("Accelerometer {available}");
        manager.setAccelerometerUpdateInterval_(1.0/60.0); //60Hz
        manager.startAccelerometerUpdates();
        for i in 1..1000 {
            let data = manager.accelerometerData();
            let acceleration = data.acceleration();
            println!("Sample {i} - {acceleration:?}");
            std::thread::sleep(std::time::Duration::from_millis(10));
        }
    }
}
```
