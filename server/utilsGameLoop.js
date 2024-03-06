'use strict'

const TARGET_FPS = 40
const TARGET_MS = 1000 / TARGET_FPS

class Obj {

    init() {
        this.run = (fps) => { console.log(fps) }

        this.running = false
        this.frameCount = 0
        this.fpsStartTime = Date.now()
        this.currentFPS = 0

        this.start()
    }

    start() {
        if (!this.running) {
            this.running = true;
            this.gameLoop();
        }
    }

    stop() {
        this.running = false;
    }

    gameLoop() {
        const startTime = Date.now()

        if (!this.running) {
            return;
        }

        if (this.currentFPS >= 1) {
            if (typeof this.run == "function") {
                this.run(this.currentFPS)
            }
        }

        const endTime = Date.now()
        const elapsedTime = endTime - startTime
        const remainingTime = Math.max(1, TARGET_MS - elapsedTime)

        this.frameCount++;
        const fpsElapsedTime = endTime - this.fpsStartTime
        if (fpsElapsedTime >= 500) {
            this.currentFPS = (this.frameCount / fpsElapsedTime) * 1000
            this.frameCount = 0
            this.fpsStartTime = endTime
        }

        setTimeout(() => { setImmediate(() => { this.gameLoop() }) }, remainingTime)
    }
}

// Export
module.exports = Obj