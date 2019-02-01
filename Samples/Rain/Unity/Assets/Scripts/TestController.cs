using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR.MagicLeap;

public class TestController : MonoBehaviour {

    #region Public Variables
    public MLInputController _controller; 
    public GameObject Info;
    public GameObject MainCamera;
    public GameObject Rain;
	public AudioSource RainSound;
    #endregion

    #region Private Variables
    private Vignette _vignette;
    private Instructions _instructions; 
    private bool _infoMode = true;
    private bool _bumperUp = false;
    private bool _homeButtonUp = false;
    private float _triggerThreshold = 0.2f;
    private bool _triggerPressed;
    #endregion

    #region Unity Methods
    void Awake() {
        MLInput.Start();
    }
        
    void Start() {
        _controller = MLInput.GetController(MLInput.Hand.Left);
        MLInput.OnControllerButtonUp += OnButtonUp;

        _vignette = MainCamera.GetComponentInChildren<Vignette>();
        _instructions = Info.GetComponentInChildren<Instructions>();

        setInfoState(true);
    }

    void OnDestroy() {
        MLInput.Stop();
    }

    void LateUpdate() {
        if (_infoMode) {
            checkTrigger();
        }
        else {
            checkBumper();
        }
        checkHomeButton();
        resetFlags();
    }
    #endregion

    #region Private Methods
    void setInfoState(bool state) {
        _infoMode = state;
        if (_infoMode) {
            Rain.SetActive(false);
			RainSound.Stop();
            _instructions.NextPage(true);
            _vignette.Reset();
        }
        else {
            Rain.SetActive(true);
			RainSound.Play();
            _vignette.ToggleVignetteState();
        }
    }
    private void resetFlags() {
        _homeButtonUp = false;
        _bumperUp = false;
    }
    private void checkHomeButton() {
        if (_homeButtonUp) {
            setInfoState(true);
        }
    }
    private void checkBumper() {
        if (_bumperUp) {
            _vignette.ToggleVignetteState();
            _controller.StartFeedbackPatternVibe(MLInputControllerFeedbackPatternVibe.Bump, MLInputControllerFeedbackIntensity.High);
        }
    }

    private void checkTrigger() {
        if (_controller.TriggerValue < _triggerThreshold) {
            _triggerPressed = false;
        }
        else {
            if (_triggerPressed == false) {
                if (!_instructions.NextPage()) {
                    setInfoState(false);
                }
                _triggerPressed = true;
            }
        }
    }
    #endregion

    #region Events    
    void OnButtonUp(byte controller_id, MLInputControllerButton button) {
        if (button == MLInputControllerButton.Bumper) {  
            _bumperUp = true;
        }
        else if (button == MLInputControllerButton.HomeTap) {          
            _homeButtonUp = true;
        }
    }
    #endregion
}


