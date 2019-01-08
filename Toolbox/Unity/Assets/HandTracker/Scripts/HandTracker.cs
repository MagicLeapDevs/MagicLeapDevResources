using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.MagicLeap;
public class HandTracker : MonoBehaviour {

    # region Private Variables
    private MLKeyPointFilterLevel _keyPointFilterLevel = MLKeyPointFilterLevel.ExtraSmoothed;
    private MLPoseFilterLevel _PoseFilterLevel = MLPoseFilterLevel.ExtraRobust;
        
    [SerializeField, Tooltip("The left hand color")]    
    private Color _leftHandColor;        
    [SerializeField, Tooltip("The right hand color")]    
    private Color _rightHandColor;
    private GameObject _handTracker;
    [SerializeField, Tooltip("The keypoint prefab")]
    private GameObject _keyPointPrefab;

    private struct HandData {
        public MLHand hand;
        public GameObject handGO;
        public Color color;
        public List<GameObject> keyPoints;

        public HandData(MLHand hand, GameObject parent, string name, Color color) {
            this.hand = hand;
            this.handGO = new GameObject(name);
            this.handGO.transform.SetParent(parent.transform);
            this.color = color;
            keyPoints = new List<GameObject>();
        }
    }
    private List<HandData> _handData = new List<HandData>();
    #endregion


    # region Unity Methods
    void Start() {

        MLResult result = MLHands.Start();
        if (!result.IsOk) {
            Debug.LogError("Error HandTrackingVisualizer starting MLHands, disabling script.");
            enabled = false;
            return;
        }

        // Set gesture parameters
        MLHands.KeyPoseManager.SetKeyPointsFilterLevel(_keyPointFilterLevel);
        MLHands.KeyPoseManager.SetPoseFilterLevel(_PoseFilterLevel);

        // One key pose is required to use keypoints
        List<MLHandKeyPose> keyPoses = new List<MLHandKeyPose>();
        keyPoses.Add(MLHandKeyPose.Finger);
        MLHandKeyPose[] keyPoseTypes = keyPoses.ToArray();
        MLHands.KeyPoseManager.EnableKeyPoses(keyPoseTypes, true, true);

        // Populate the keypoint data
        setup();
    }

    void OnDestroy() {
        if (MLHands.IsStarted) {
            MLHands.Stop();
        }
    }

    void Update() { 
        // Update the keypoints 
        updateKeyPoints();
    }
    #endregion

    # region Private Methods

    private void setup() {

        // Create top-level gameObject
        _handTracker = new GameObject("HandTracking");
        _handData.Add(new HandData(MLHands.Left, _handTracker, "Left Hand", Color.cyan));
        _handData.Add(new HandData(MLHands.Right, _handTracker, "Right Hand", Color.yellow));
        //_handData.Add(new HandData(MLHands.Left, _handTracker, "Left Hand", _leftHandColor));
        //_handData.Add(new HandData(MLHands.Right, _handTracker, "Right Hand", _rightHandColor));
    }

    private void updateKeyPoints() {

        foreach (HandData handData in _handData) {
            MLHand hand = handData.hand;
            updateKeyPosition( 0, "Hand Center", hand.Center,  handData);
            updateKeyPoint( 1, "Thump Tip", hand.Thumb.Tip, handData);
            updateKeyPoint( 2, "Thump MCP", hand.Thumb.MCP, handData);
            updateKeyPoint( 3, "Index Tip", hand.Index.Tip, handData);
            updateKeyPoint( 4, "Index PIP", hand.Index.PIP, handData);
            updateKeyPoint( 5, "Index MCP", hand.Index.MCP, handData);
            updateKeyPoint( 6, "Middle MCP", hand.Middle.MCP, handData);
            updateKeyPoint( 7, "Wrist Center", hand.Wrist.Center, handData);
        }      
    }

    private void updateKeyPosition(int index, string name, Vector3 keyPointPosition, HandData handData) {

        // First time through populate keypoints
        if (handData.keyPoints.Count <= index) {

            // Create keyPoint prefab and parent it      
            GameObject obj = Instantiate(_keyPointPrefab);
            obj.transform.SetParent(handData.handGO.transform);

            // Find the KeyPoint script
            KeyPoint keyPoint = obj.GetComponentInChildren<KeyPoint>();

            // Set the main camera
            keyPoint._MainCam = gameObject;

            // Set sphere properties
            GameObject sphere = keyPoint._sphere;
            sphere.name = name + " Sphere";
            sphere.GetComponent<Renderer>().material.color = handData.color;

            // Set label properties
            GameObject label = keyPoint._label;
            label.GetComponent<UnityEngine.UI.Text>().text = name;
            label.GetComponent<UnityEngine.UI.Text>().color = handData.color;

            handData.keyPoints.Add(obj);
        }

        // Update keypoints transforms
        handData.keyPoints[index].transform.position = keyPointPosition;
    }

    private void updateKeyPoint(int index, string name, MLKeyPoint keyPoint, HandData handData) {
        if (keyPoint.IsValid) {
            updateKeyPosition(index, name, keyPoint.Position, handData);
        }
    }
    #endregion
}
