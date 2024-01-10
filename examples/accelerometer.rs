use coremotion::{CMMotionManager, ICMAccelerometerData, ICMMotionManager, INSObject};

use log::LevelFilter;
use oslog::OsLogger;

fn main() {
    OsLogger::new("com.simlay.net")
        .level_filter(LevelFilter::Debug)
        .category_level_filter("Settings", LevelFilter::Trace)
        .init()
        .unwrap();

    let manager = CMMotionManager::alloc();
    unsafe {
        manager.init();
        let available = manager.isAccelerometerAvailable();
        log::info!("Accelerometer {available}");
        //manager.setAccelerometerUpdateInterval_(10.0);
        manager.startAccelerometerUpdates();
        for i in 1..1000 {
            let data = manager.accelerometerData();
            let acceleration = data.acceleration();
            log::info!("Sample {i} - {acceleration:?}");
            std::thread::sleep(std::time::Duration::from_millis(10));
        }
    }
}
