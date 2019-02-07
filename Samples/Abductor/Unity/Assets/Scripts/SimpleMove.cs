using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.MagicLeap;

namespace LR_Samples {
    public class SimpleMove : MonoBehaviour {

        //public GameObject abductionDemo;
        public GameObject controller;
        private SceneController _controller;
        private GameObject camMain;
    
        public float speed = .05f;
        public float maxSpeed = .5f;

        void Start() {
            _controller = controller.GetComponent<SceneController>();
            camMain = GameObject.Find("Main Camera");

            // Move forward along the plane
            //Vector3 forward = Vector3.Normalize(Vector3.ProjectOnPlane(camMain.transform.forward, Vector3.up));
        }
        void Update () {

            if (_controller.controller.Touch1PosAndForce.z > 0.0) {

                Vector3 forward = Vector3.Normalize(Vector3.ProjectOnPlane(camMain.transform.forward, Vector3.up));
                Vector3 right = Vector3.Normalize(Vector3.ProjectOnPlane(camMain.transform.right, Vector3.up));

                float deltaX = _controller.controller.Touch1PosAndForce.x;
                float deltaY = _controller.controller.Touch1PosAndForce.y;
                Vector3 forceVector = Vector3.Normalize((deltaX * right) + (deltaY * forward));

                Rigidbody rb = GetComponent<Rigidbody>();
                rb.AddForce(speed * forceVector, ForceMode.Impulse);

                if(rb.velocity.magnitude > maxSpeed){
                    rb.velocity = Vector3.ClampMagnitude(rb.velocity, maxSpeed);
                }
            }   
            setAltitude(gameObject.transform.position);
        }

        public void initPosition(Vector3 newPosition) {
            gameObject.transform.position = newPosition;
        }

        void setAltitude(Vector3 newPosition) {

            int layerMask = 1 << 9; // Ground Layer = 9
            float sphereRadius = 0.30f;
            float alt = .10f;
            RaycastHit sphereHit;

            Vector3 origin = new Vector3(newPosition.x, newPosition.y+5, newPosition.z);

            bool sphereHitTest = Physics.SphereCast(origin, sphereRadius, -Vector3.up, out sphereHit, Mathf.Infinity, layerMask);
            if (sphereHitTest) {
            
                float d = Vector3.Distance(sphereHit.point, new Vector3(origin.x, sphereHit.point.y, origin.z));
                Vector3 sphereCenter = new Vector3(origin.x, sphereHit.point.y+(sphereRadius-d), origin.z);

                Vector3 finalPosition = new Vector3(sphereCenter.x, sphereCenter.y+alt, sphereCenter.z);

                gameObject.transform.position = Vector3.Lerp(gameObject.transform.position, finalPosition, 1.0f*Time.deltaTime);
            }
        }
    }
}

