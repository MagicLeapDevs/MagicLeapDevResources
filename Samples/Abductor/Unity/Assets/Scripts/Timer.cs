//using System.Collections;
//using System.Collections.Generic;
using UnityEngine;

public class Timer {
    private float startTime;

    public void start() {
        startTime = Time.time;
    }
    public void stop() {
        startTime = -1;
    }
    public float getTime() {
        float returnTime = -1f;
        if (startTime > 0f) {
            returnTime = Time.time - startTime; 
        }
        return returnTime;
    }

}
