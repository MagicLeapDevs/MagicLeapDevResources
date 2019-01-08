using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR.MagicLeap;



public class Controller : MonoBehaviour {

    public MLInputController _controller;
    private float _TRIGGER_THRESHOLD = 0.2f;
    public bool _homeButtonUp;

    void Awake() {
        var result = MLInput.Start(); 
        if (!result.IsOk) {
            Debug.LogError("Error ControllerCalibration starting MLInput, disabling script.");
            enabled = false;
             return;
        }
    }
        
    void Start() {
        _controller = MLInput.GetController(MLInput.Hand.Left);

        MLInput.OnControllerButtonUp += OnButtonUp;
    }

    void OnDestroy() {
        MLInput.Stop();
    }    

    public float triggerValue() {
        return _controller.TriggerValue;
    }

    public bool trigger {
        get {return _controller.TriggerValue >= _TRIGGER_THRESHOLD;}
    }

    #region Events 

    // Get Button Up states   
    void OnButtonUp(byte controller_id, MLInputControllerButton button) {
        if (button == MLInputControllerButton.Bumper) {  
            //_bumperUp = true;
        }
        else if (button == MLInputControllerButton.HomeTap) {          
            _homeButtonUp = true;
        }
    }
    #endregion

}
