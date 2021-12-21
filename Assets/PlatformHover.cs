using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlatformHover : MonoBehaviour
{
    public float bounceSpeed = 1f;
    public float bounceHeight = 1f;
    void Update()
    {
        transform.position = new Vector3(transform.position.x,Mathf.PingPong(Time.time * bounceSpeed,bounceHeight)- bounceHeight/2,transform.position.z);
        
    }
    
}
