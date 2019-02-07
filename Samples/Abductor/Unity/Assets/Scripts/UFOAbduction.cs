using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.MagicLeap;

namespace LR_Samples {
    public class UFOAbduction : MonoBehaviour {

        public GameObject Controller;
        public GameObject AbductionPoint;
        public GameObject SoundBeam;
        public GameObject UFO_Beam;

        private SceneController _controller;
        private ParticleSystem _explosion;
        private AudioSource audio_destroyCat;
        private AudioSource audio_beam;
        private GameObject target = null; // current GameObject being abducted
            
        private float aductionSpeed = 0.4f;
        private float rotateSpeed = 100f;   
        private float captureRadius = 0.05f; 
        private float TRIGGER_MIN = 0.2f; 

        // BeamRipplesMult - Number of ripples is a multiplier of beam length
        private float _beamRipplesMult = 40.0f;
        private Vector3 randVec;
        void Start () {
            audio_destroyCat = AbductionPoint.GetComponent<AudioSource>();
            audio_beam = SoundBeam.GetComponent<AudioSource>();
            _controller = Controller.GetComponent<SceneController>();
            _explosion = AbductionPoint.GetComponentInChildren<ParticleSystem>();
        }

        void Update() {

            float triggerVal = _controller.controller.TriggerValue;
            if (triggerVal > TRIGGER_MIN) {

                if (!audio_beam.isPlaying) {
                    audio_beam.Play();               
                }

                // Target - pull cat to ufo
                if (target) {

                    // Haptic
                    _controller.haptic_tick(MLInputControllerFeedbackIntensity.Low);
                        
                    // Beam - constant position and random constant rotation
                    target.transform.position += (AbductionPoint.transform.position - target.transform.position).normalized * (aductionSpeed * Time.deltaTime * triggerVal);
                    target.transform.Rotate(randVec, (rotateSpeed * Time.deltaTime * triggerVal));

                    if (Vector3.Distance(target.transform.position, AbductionPoint.transform.position) < 0.1f) {
                        destroyTarget();
                    }
                }

                // No target, beam goes to nearest ground
                else {
                    acquireTarget();
                }

                setBeamToGround();
            }

            // Drop target
            else {
                setBeamLength(0f);
                if (target) {
                    setTargetState(true, false, true);
                    target = null;
                }
            }
        }        
        void acquireTarget() {
            target = null;
            Vector3 origin = AbductionPoint.transform.position;
            int layerMask = 1 << 8; // Cat Layer = 8
            RaycastHit[] hits = (Physics.SphereCastAll(origin, captureRadius, -Vector3.up, Mathf.Infinity, layerMask));
            float distance = -1f;
            foreach (RaycastHit hit in hits) {
                float d = Vector3.Distance(origin, hit.collider.gameObject.transform.position);
                if ((distance < 0) || (d < distance)) {
                    distance = d;
                    target = hit.collider.gameObject;
                }
            }

            if (target) {
                initTarget();
            }
        }

        void initTarget() {

            // Set a random rotation to use while abducting
            randVec = new Vector3(Random.Range(-30.0f, 30.0f), Random.Range(-30.0f, 30.0f), Random.Range(-30.0f, 30.0f));

            setTargetState(false, true, false);
        }

        void multiRaycast(Vector3 start, Vector3 direction, int layerMask, List<RaycastHit> hits) {
            RaycastHit hit;
            bool rayHitTest = Physics.Raycast(start, direction, out hit, Mathf.Infinity, layerMask);
            if (rayHitTest) {
                //Debug.Log("hit: " + start + " " + hit.point);
                hits.Add(hit);
                multiRaycast(hit.point+(0.001f*direction), direction, layerMask, hits);
            } 
            else {
                //Debug.Log("no hit" + start);
            }   
        }

        // setBeamToGround
        // Extend the beam length from the ufo to the ground
        // There can be multiple levels of mesh below the ufo
        // If no target, find nearest mesh intersection
        // If target, find nearest mesh intersection below target.
        // If no mesh below target, extend bend to target distance
        void setBeamToGround() {
            Vector3 origin = UFO_Beam.transform.position;
            int layerMask = 1 << 9; // Ground Layer = 9
            float distance = 0f;
            if (target) {
                List<RaycastHit> hits = new List<RaycastHit>();
                multiRaycast(origin, -Vector3.up, layerMask, hits);
                float targetDistance = Mathf.Abs(origin.y - target.transform.position.y);

                // No mesh below target, extend to target distance
                if (hits.Count == 0) {
                    distance = targetDistance;
                }

                // Find nearest mesh intersection below target
                else {
                    foreach (RaycastHit hit in hits) {
                        float groundDistance = Mathf.Abs(origin.y - hit.point.y);
                        if (groundDistance > targetDistance) {
                            if ((distance < Mathf.Epsilon) || (groundDistance < distance)) {
                                distance = groundDistance;
                            }
                        }
                    }
                }
            }

            // No target, find nearest mesh intersection
            else {
                RaycastHit hit;
                bool rayHitTest = Physics.Raycast(origin, -Vector3.up, out hit, Mathf.Infinity, layerMask);
                if (rayHitTest) {
                    distance = Mathf.Abs(origin.y - hit.point.y);
                }
            }
            setBeamLength(distance);
        }

        void destroyTarget() {
            if (audio_beam.isPlaying) {
                audio_beam.Stop();
            }
            _controller.haptic_bump(MLInputControllerFeedbackIntensity.High);
            audio_destroyCat.Play();

            // Play explosion particle system
            _explosion.Stop();
            _explosion.Play();
            
            Destroy(target);
            target = null;            
        }

        void setTargetState(bool lookAt, bool kinematic, bool dropped) {
            target.GetComponent<Rigidbody>().isKinematic = kinematic;
            Cat catPrefabScript = target.GetComponentInChildren<Cat>();
            if (catPrefabScript != null) {
                    catPrefabScript.enableLookAt = lookAt;
                    catPrefabScript.dropped = dropped;
            }
        }

        void setBeamLength(float length) {
            UFO_Beam.GetComponentInChildren<MeshRenderer>().material.SetFloat("_Length", length);
            UFO_Beam.GetComponentInChildren<MeshRenderer>().material.SetFloat("_Ripples", (length * _beamRipplesMult));
        }
    }
}
