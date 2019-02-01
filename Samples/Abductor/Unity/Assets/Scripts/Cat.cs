using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cat : MonoBehaviour {

    private Transform camMainTrans;
    private Vector3 camPosition;
    //private bool firstBounce = false;
    public bool enableLookAt = true;
    public bool dropped = false;
    //private bool bouncing = false;
    //private bool stopBouncing = false;
    private Rigidbody rigidBody;
    private Vector3 oldPosition;

	void Start () {
		camMainTrans = GameObject.Find("Main Camera").transform;
        rigidBody = GetComponent<Rigidbody>();
	}
	
	void Update () {		
        if (enableLookAt) {
            Vector3 oldPosition = gameObject.transform.position;
            camPosition = new Vector3(camMainTrans.position.x, gameObject.transform.position.y, camMainTrans.position.z);
            gameObject.transform.LookAt(camPosition, Vector3.up);
            gameObject.transform.position = new Vector3(oldPosition.x, oldPosition.y, oldPosition.z);

            //Vector3 relativePos = camMainTrans.position - gameObject.transform.position;
            //gameObject.transform.rotation = Quaternion.LookRotation (relativePos);
        }
    }
    void setLookAtState(bool state) {
        enableLookAt = state;
    }

    // Cat bounce(temporary)
    // Using a physics material is having issues - needs more testing
    // 1) cats sliding on mesh after bounce
    // 2) if kinematics set, cat may not sop on mesh
	/*void FixedUpdate() {

        // hit ground - bouncing - add up force
        if (firstBounce) {
            rigidBody.isKinematic = false;
            rigidBody.AddForce(transform.up * 100); // Add a force
            firstBounce = false; // first bopunce done
            dropped = false; // turn off dropped state
            bouncing = true; // turn on bouncing
        }

        // done bouncing
        else if (stopBouncing) {
            bouncing = false; 
            stopBouncing = false;
            rigidBody.isKinematic = true;           
        }
	}*/

    void OnCollisionEnter(Collision col) {
        rigidBody.isKinematic = true;
        // Dropped from abduction - 1st hit - start bouncing
        /*if (dropped && (col.gameObject == GameObject.FindWithTag("GroundMesh"))) {
            firstBounce = true;
        }

        // bouncing - 2nd hit on ground - stop bouncing
        else if (bouncing && (col.gameObject == GameObject.FindWithTag("GroundMesh"))) {
            rigidBody.velocity = Vector3.zero; // set velocity zero
            rigidBody.isKinematic = true; // turn off rigid bodies
            stopBouncing = true; // stop bopuncing
        }*/
    }
}
