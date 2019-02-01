using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rain : MonoBehaviour {

    #region Public Variables
    public ParticleSystem _ripples;
    public ParticleSystem _splashes;
    #endregion

    #region Private Variables
    private ParticleSystem _partSystem;
    private List<ParticleCollisionEvent> _collisionEvents;
    #endregion
    
    #region Unity Methods
	void Awake () {
		_collisionEvents = new List<ParticleCollisionEvent>();
        _partSystem = GetComponent<ParticleSystem>();
        _ripples.Stop();
        _ripples.Play();
	}

    // OnParticleCollision
    // GameObject parameter varies based on what script is attahced to
    // Part System - gameObject is the collider object
    // Collider Object - gameObject is the part system
    private void OnParticleCollision(GameObject groundMesh) {
        _partSystem.GetCollisionEvents(groundMesh, _collisionEvents);
        for (int i=0; i<_collisionEvents.Count;i++) {
            EmitAtLocation(_collisionEvents[i]);
        }
        _collisionEvents.Clear();
    }
    #endregion

	
    #region Private Methods
    private void EmitAtLocation(ParticleCollisionEvent collisionEvent) {
        //Debug.Log("intersection: " + collisionEvent.intersection + " " + collisionEvent.normal);
        _ripples.transform.position = collisionEvent.intersection;
        //_ripples.transform.rotation = Quaternion.LookRotation(collisionEvent.normal);
        _ripples.transform.rotation = Quaternion.LookRotation(Vector3.up);
        _ripples.Play();

        _splashes.transform.position = collisionEvent.intersection;
        //_splashes.transform.rotation = Quaternion.LookRotation(collisionEvent.normal);
        _splashes.transform.rotation = Quaternion.LookRotation(Vector3.up);
        _splashes.Emit(Random.Range(4, 13));
    }
    #endregion
}
