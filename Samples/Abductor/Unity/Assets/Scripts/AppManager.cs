using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using MagicLeap;
using UnityEngine.XR.MagicLeap;


/*
1) Info State
    a) bumper pages through info pages
    b) on page 3 bumper starts game

2) Game state
    a) OK gesture spawns cats
    b) wave hand - back to info state
    c) bumper 5 sec - toggle mesh visibility
    d) bumper 10 sec - reset game
 */
public class AppManager : Singleton {

    // Links to other GameObjects
    public GameObject Controller;
    public GameObject Game;
    public GameObject Info;
    public GameObject Panel;
    public GameObject Spawner;
    public GameObject UFO;
    public GameObject Meshing;

    // Links to components on other GameObjects
    private Controller _controller;
    private Meshing _meshing;
    private Spawner _spawner;

    //Possible states of the App
    private enum StateType { INFO, GAME };
    private StateType appState = StateType.INFO;
    private string _infoPath = "Info/Canvas/Info";

    // Index of current info page
    private int infoIndex;

    // scanning - state whether scanning was toggled this frame
    private bool _scanning = false;

    // triggerDown - state whether the trigger was down this frame
    private bool _triggerDown = false;
    
    // Time bumper is held down to toggle scanning
    private float _TIME_MESH_SCANNING_TOGGLE = 5f;

    // Minimum value of trigger
 

    void Start() {

        // Links to scripts on other game Objects
        _controller = Controller.GetComponentInChildren<Controller>();
        _meshing = Meshing.GetComponentInChildren<Meshing>();
        _spawner = Spawner.GetComponentInChildren<Spawner>();

        // Load up game gestures
        _controller.setupGestures();

        // Reset the game states
        reset();
    }

    // LateUpdate - so we know we are after button callbacks?
    void LateUpdate() {

        // Update gesture states for this frame
        _controller.updateGestureStates();

        // InfoState - display and page through Info screens
        if (appState == StateType.INFO) {
            if (_controller.trigger) {
                if (!_triggerDown) {
                    _controller.haptic_forceDown(MLInputControllerFeedbackIntensity.Low);          
                    if (infoIndex == 4) {
                        GameState();
                    }
                    else {
                        infoIndex++;
                        setInfoIndex(infoIndex);
                    }
                }
                _triggerDown = true;
            }
            else {
                _triggerDown = false;
            }
        }

        // GameState - Display world, ufo, spawn cats
        else if (appState == StateType.GAME) {

            // Reset the game when the Home Button is pressed
            if (_controller.homeButtonPressed) {
                _controller.haptic_forceDown(MLInputControllerFeedbackIntensity.High);          
                reset();
            }

            // Spawner the Cat Prefabs when the OK Gesture is recognized
            if (_controller.okGesture && !_spawner._prefabsPopulated) {
                _controller.haptic_forceDown(MLInputControllerFeedbackIntensity.Low);          
                populatePrefabs();
            }

            // Toggle Mesh updates when the Bumper Button is held down for a set amount of time
            if (_controller.bumperTimer.getTime() >= _TIME_MESH_SCANNING_TOGGLE) {
                _controller.haptic_forceUp(MLInputControllerFeedbackIntensity.Medium);          
                _meshing.toggleMeshScanning();
                _controller.bumperTimer.start();
                _scanning = true;
            }

            // Toggle mesh visibility when the Bumper button is held down briefly
            if (_controller.bumperUp) {

                // Skip mesh visibility toggle, when releasing Bumpert button after successful mesh scanning toggle
                if (_scanning) {
                    _scanning = false;
                }

                // Toggle mesh visibility
                else {
                    _meshing.toggleMeshVisibility();
                }
            }
        }

        // Reset controller states
        _controller.resetFrame();
    }

    // reset - initialize and display info screens
    void reset() {
        // Destroy prefabs
        _spawner.cleanup();
        // Turn on meshing and mesh visibility states
        _meshing.resetMeshing();
        // Switch to Info State
        InfoState();
    }

    // Start the UFO in the correct location
    void initUFO() {
        UFO.SetActive(true);
        SimpleMove simpleMove = UFO.GetComponentInChildren<SimpleMove>();
        simpleMove.initPosition(Spawner.transform.position);
    }

    // Create the prefabs, hide the spawner box volume
    void populatePrefabs() {
        _spawner.populatePrefabs();
        _spawner.setSpawnerVisibility(false);
    }

    // Set active the info screen with the index (screens named Info0...Info3)
    void setInfoIndex(int index) {
        infoIndex = index;
        for (int i=0;i<5;i++) {
            GameObject.Find(_infoPath + i).SetActive(i == index);
        }
    }

    // Set the Info State - Hide the world and display and page through Info Screens
    void InfoState() {
        appState = StateType.INFO;
        Panel.SetActive(true); 
        Info.SetActive(true);         
        UFO.SetActive(false); 
        _spawner.setSpawnerVisibility(false);
        setInfoIndex(0);
    }

    // Set the Game State - Hide the info screens, display the UFO and world
    void GameState() {
        appState = StateType.GAME;
        Info.SetActive(false);
        Panel.SetActive(false);
        _spawner.setSpawnerVisibility(true);
        _controller.triggerEnabled = false;
        initUFO();
    }
}
