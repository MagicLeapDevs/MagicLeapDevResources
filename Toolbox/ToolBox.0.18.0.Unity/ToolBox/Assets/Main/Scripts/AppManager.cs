using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR.MagicLeap;
using UnityEngine.SceneManagement;
using UnityEngine.EventSystems;

public class AppManager : Singleton {

    # region Private Variables
    private List<string> _scenes = new List<string> {
        "Main",
        "AmbientBoost",
        "CaptureOffset",
        "HandTracker",
        "ClippingPlaneTool",                                                        
        "LaserPointer",
        "Meshing",                                                         
        "Vignette"
    };

    private int _sceneIndex = 0;
    private Controller _controller;
    private Instructions _instructions;
    private GameObject _info;
    #endregion
 
    # region Unity Methods
    void Start() {

        _controller = GetComponentInChildren<Controller>();

        // Add Trigger callback
        MLInput.OnTriggerDown += HandleOnTriggerDown;
    }
    void OnDestroy() {
        MLInput.OnTriggerDown -= HandleOnTriggerDown;
    }

    void Update() {

        if (_controller._homeButtonUp) {
            _controller._homeButtonUp = false;
            resetScene();
            return;
        }  
    }
    #endregion

    # region Private Methods

    // Load scene frm list index
    private void loadScene(int index) {
        string sceneName = ("Assets/" + _scenes[index] + "/Scenes/Main.unity");
        SceneManager.LoadScene(sceneName);
    }

    private void resetScene() {
        Camera mainCamera = Camera.main;

        GameObject sceneObject = GameObject.FindGameObjectWithTag("sceneObject");
        if (sceneObject != null) {
            sceneObject.transform.position = mainCamera.transform.position;
            sceneObject.transform.rotation = Quaternion.Euler(0f, mainCamera.transform.rotation.eulerAngles.y, 0f);
        }                
    }
    #endregion

    # region Public Methods
    public void nextScene() {
        Debug.Log("[nextScene]");
        _info = GameObject.Find("Info");
        if (_info) {
            _instructions = _info.GetComponentInChildren<Instructions>();
            if ( _instructions.NextPage(false)) {
                return;
            }
        }
        _sceneIndex++;
        int _index = _sceneIndex % _scenes.Count;
        loadScene(_index);
    } 
    #endregion

    #region Event Handlers
    private void HandleOnTriggerDown(byte controllerId, float value) {
        int idx = _sceneIndex % _scenes.Count;
        if (idx == 0) {
            if (LaserPointer._buttonObject != null) {
                PointerEventData pointer = new PointerEventData(EventSystem.current);
                ExecuteEvents.Execute(LaserPointer._buttonObject, pointer, ExecuteEvents.submitHandler);
            }
        }
        else {
            nextScene();
        }
    }
    #endregion
}
