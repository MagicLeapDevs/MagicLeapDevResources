using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR.MagicLeap;

namespace LR_Samples {

    public class Ghost : MonoBehaviour {

        # region Private Variables
        [SerializeField] GameObject _MainCam;
        [SerializeField] GameObject _DistanceText;
        [SerializeField] float _startDistance = 1.0f;
        [SerializeField] float _reappearTime = 2.0f;
        [SerializeField] float _CLIP_DISTANCE = 0.5f;
        [SerializeField] bool _enableLookAt = true;

        [SerializeField] AnimationCurve disappearCurve;
        [SerializeField] AudioClip _ghostDisappear;
        [SerializeField] AudioClip _ghostAppear;
        [SerializeField] AudioClip _ghostFreeze;
        [SerializeField] AudioClip _ghostUnfreeze;
        [SerializeField] AudioClip [] _ghostcackles;

        private AudioSource _audioSource;    
        private SceneController _controller;
        private Text _distanceText;

        private float _distance;
        private bool _teleporting = false;
        private bool _frozen = false;
        private Color _ghostGreen = new Color(0.03f, 1.0f, 0.28867f, 1.0f);
        private Color _ghostRed = new Color(1.0f, 0.0f, 1.0f, 1.0f);
        private Color _ghostBlue = new Color(0.03f, 0.363023f, 1.0f, 1.0f);
        private float _ghostFloatSpeed = 17.737f;
        private float _ghostRippleSpeed = 0.5f;
        private float _ghostWispSpeed = 0.5f;
        #endregion
        
        #region Unity Methods
        void Start() {
            _distanceText = _DistanceText.GetComponentInChildren<Text>();
            _audioSource = GetComponentInChildren<AudioSource>();
            _controller = GetComponentInChildren<SceneController>();

            spawnGhost();
        }
        void Update () {

            // Update distance display with distance from camera to ghost
            _distance = Vector3.Distance(_MainCam.transform.position, transform.position);
            updateDistanceText();

            // Ghost looks at camera (unless frozen or teleporting)
            if (!_teleporting && !_frozen &&_enableLookAt) {
                ghostLookAtCamera();
            }

            // Ghost teleports when it clips the camera (unless it is already teleporting or frozen)       
            if (!_teleporting && !_frozen && (_distance <= _CLIP_DISTANCE)) {
                _teleporting = true;
                StartCoroutine(Disappear());
            }
        }
        #endregion

        #region Public Methods

        // spawnGhost
        // Sets the ghost gameObject active
        // reset states (frozen and teleport)
        // Sets the ghost position relative to the HMD
        // Sets ghost color and material properties
        // Play random ghost cackle
        public void spawnGhost() {
            gameObject.SetActive(true);
            _frozen = false;
            _teleporting = false;
            resetGhost();
            SetGhostColor(_ghostGreen);
            //SetGhostColor(Color.green);
            setGhostMaterialProperties();
            playRandomGhostCackle();
        }

        // hideGhost
        // Sets the ghost gameObject inactive
        public void hideGhost() {
            gameObject.SetActive(false);
        }

        // Toggle Freeze
        // Toggle ghost frozen state
        // Changes color between green(unfrozen) and blue(frozen)
        // Plays audio clips (freeze, unfreeze + random cackle)
        public void ToggleFreeze() {
            _frozen = _frozen ? false : true;
            if (_frozen) {
                _controller.haptic_bump(MLInputControllerFeedbackIntensity.High);
                SetGhostColor(_ghostBlue);
                setGhostMaterialProperty("_FloatSpeed",    0.0f);   
                setGhostMaterialProperty("_RippleSpeed",    0.05f);   
                setGhostMaterialProperty("_RippleSpeed",    0.01f);   
                //SetGhostColor(Color.blue);
                playGhostClip(_ghostFreeze);
            }
            else {
                _controller.haptic_bump(MLInputControllerFeedbackIntensity.High);
                SetGhostColor(_ghostGreen);
                setGhostMaterialProperty("_FloatSpeed",    _ghostFloatSpeed);   
                setGhostMaterialProperty("_RippleSpeed",    _ghostRippleSpeed);   
                setGhostMaterialProperty("_RippleSpeed",    _ghostWispSpeed);   
                //SetGhostColor(Color.green);  
                StartCoroutine(PlayTwoAudioClips(_ghostUnfreeze, getRandomCackleClip()));
            }
        }

        #endregion

        #region Private Methods

        // ghostLookAtCamera
        // Ghost will orient to follow HMD
        private void ghostLookAtCamera () {		
            Vector3 relativePos = _MainCam.transform.position - transform.position;
            transform.rotation = Quaternion.LookRotation (relativePos);
        }

        // updateDistanceText
        // Updates the text field of the distance widget with distance from HMD to ghost
        private void updateDistanceText() {
            _distanceText.text = (_distance*100).ToString("F0") + " cm";
        }

        // resetGhost
        // Positions ghost relative to HMD (100cm in front and 20 cm down)
        private void resetGhost() {
            Vector3 forward = Vector3.Normalize(Vector3.ProjectOnPlane(_MainCam.transform.forward, Vector3.up));
            Vector3 newPosition = _MainCam.transform.position + (_startDistance * forward);
            newPosition.y -= 0.2f;
            transform.position = newPosition;
        }

        // Coroutine Disappear 
        // enables teleporting state and plays audio (disappear clip)
        // scales ghost over animation curve (0.3 secs)
        // launches Reappear Coroutine
        private IEnumerator Disappear() {
            _teleporting = true;
            playGhostClip(_ghostDisappear);
            _controller.haptic_bump(MLInputControllerFeedbackIntensity.High);
            for (float t=0.0f;t<0.3;t+=Time.deltaTime) {
                float val = disappearCurve.Evaluate(t);
                transform.localScale = Vector3.one * val;
                yield return null;
            }
            transform.localScale = Vector3.zero;
            StartCoroutine(Reappear());
        }

        // Coroutine Reappear 
        // sets teleporting state and plays audio
        // disables teleporting state and plays sequential audio (reappear clip + random cackle)
        private IEnumerator Reappear() {
            yield return new WaitForSecondsRealtime(_reappearTime);
            resetGhost();
            _teleporting = false;
            transform.localScale = Vector3.one;
            _controller.haptic_bump(MLInputControllerFeedbackIntensity.High);
            StartCoroutine(PlayTwoAudioClips(_ghostAppear, getRandomCackleClip()));
        }

        // playGhostClip
        // Plays an audio clip
        private void playGhostClip(AudioClip audioClip) {
            _audioSource.clip = audioClip;
            _audioSource.Play();
        }

        // getRandomCackleClip
        // Returns a random clip from the array of "cackle" clips
        private AudioClip getRandomCackleClip() {
            return _ghostcackles[Random.Range(0, _ghostcackles.Length-1)];
        }

        // playRandomGhostCackle
        // Plays a random cackle from the array of "cackle" clips
        private void playRandomGhostCackle() {
            _audioSource.clip = getRandomCackleClip();
            _audioSource.Play();
        }

        // CoRoutine PlayTwoAudioClips
        // Plays two clips sequentially (used for Reappear, unfreeze)
        private IEnumerator PlayTwoAudioClips(AudioClip clip1, AudioClip clip2) {
            _audioSource.clip = clip1;
            _audioSource.Play();
            while (_audioSource.isPlaying) {
                yield return null;
            }
            _audioSource.clip = clip2;
            _audioSource.Play();
        }

        // SetGhostColor
        // Sets the ghost body color material property
        private void SetGhostColor(Color color) {
            Material mat = GetComponentInChildren<MeshRenderer>().materials[0];
            if (mat.HasProperty("_ColorBody")) {
                mat.SetColor("_ColorBody", color);
            }
        }  

        // setGhostMaterialProperties
        // Sets the material properties for the ghost shader
        private void setGhostMaterialProperties() {
            Material mat = GetComponentInChildren<MeshRenderer>().materials[0];
            if (mat.HasProperty("_ColorEyes")) mat.SetColor("_ColorEyes", _ghostRed);
            setGhostMaterialProperty("_FaceOffset_U",  -0.114286f);
            setGhostMaterialProperty("_FaceOffset_V",  -0.104762f);
            setGhostMaterialProperty("_FaceSize_U",    1.208626f);
            setGhostMaterialProperty("_FaceSize_V",    1.231869f);
            setGhostMaterialProperty("_EmissiveBody",  107.189331f);
            setGhostMaterialProperty("_EmissiveEyes",  993.68634f);
            setGhostMaterialProperty("_FloatSpeed",    _ghostFloatSpeed);
            setGhostMaterialProperty("_FloatMagnitude",  5.55f);

            setGhostMaterialProperty("_WispMagnitude", 0.1f);
            setGhostMaterialProperty("_WispPower",     3.0f);
            setGhostMaterialProperty("_WispPower2",    4.0f);
            setGhostMaterialProperty("_WispSpeed",     _ghostWispSpeed);
            setGhostMaterialProperty("_WispTiling_U",  2.0f);
            setGhostMaterialProperty("_WispTiling_V",  0.1f);

            setGhostMaterialProperty("_RippleMagnitude",  0.009f);
            setGhostMaterialProperty("_RippleFade",  8.0f);
            setGhostMaterialProperty("_RippleSpeed",  _ghostRippleSpeed);
            setGhostMaterialProperty("_RippleTiling",  8.0f);

            setGhostMaterialProperty("_OpacityPower",  8.0f);
            

        }  

        // setGhostMaterialProperty
        // Helper method to set material properties
        private void setGhostMaterialProperty(string property, float val) {
            Material mat = GetComponentInChildren<MeshRenderer>().materials[0];
            if (mat.HasProperty(property)) {
                mat.SetFloat(property, val);
            }
            else {
                Debug.Log("material has no property: " + property);
            }
        }
        #endregion
    }
}

