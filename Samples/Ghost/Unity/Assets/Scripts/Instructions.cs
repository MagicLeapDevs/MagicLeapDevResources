using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Instructions : MonoBehaviour {

    # region Private Variables
    [SerializeField] GameObject _Pages;
    [SerializeField] Camera _Camera;
    [SerializeField] GameObject _Canvas;
    private int _pageIndex = 0;
    private List<GameObject> _pages = new List<GameObject>();
    #endregion

    # region Unity Methods
    void Awake()
    {
        if (_Camera == null) {
            _Camera = Camera.main;
        }

        gameObject.transform.position = _Camera.transform.position + _Camera.transform.forward * 1.0f;
        gameObject.transform.rotation = _Camera.transform.rotation;

        // Store the pages, child GameObjects of the Pages gameObject
        for (int i=0;i<_Pages.transform.childCount;i++) {
            _pages.Add(_Pages.transform.GetChild(i).gameObject);
        }
    }

    void Update () {
        float speed = Time.deltaTime * 5f;

        Vector3 pos = _Camera.transform.position + _Camera.transform.forward *1.0f;
        gameObject.transform.position = Vector3.SlerpUnclamped(gameObject.transform.position, pos, speed);

        Quaternion rot = Quaternion.LookRotation(gameObject.transform.position - _Camera.transform.position);
        gameObject.transform.rotation = Quaternion.Slerp(gameObject.transform.rotation, rot, speed);

    }
    #endregion

    # region Public Methods
    public bool NextPage(bool reset = false) {

        // If reset, set pageIndex to 0, else increment pageIndex
        _pageIndex++;
        if (reset) {
             _pageIndex = 0;
        }

        // If last page, hide info screens, return false
        if (_pageIndex >= _pages.Count) {
            SetVisibility(false);
            return false;
        }

        // Set visibility of pageIndex screen
        for (int i=0;i<_pages.Count;i++) {
            _pages[i].SetActive(i == _pageIndex);
        }  

        // Show info screens, return true
        SetVisibility(true); 
        return true; 
    }
    #endregion

    # region Private Methods
    private void SetVisibility(bool state) {
        _Canvas.SetActive(state);
    }
    #endregion

}
