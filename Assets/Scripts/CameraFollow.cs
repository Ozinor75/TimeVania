using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    public Rigidbody2D toFollow;
    public float followTime;
    public float offsetZ;
    public float offsetY;

    // Update is called once per frame
    void FixedUpdate()
    {
        Vector3 self2Dpos = new Vector3(transform.position.x, transform.position.y + offsetY, - offsetZ);
        Vector3 other2Dpos = new Vector3(toFollow.position.x, toFollow.position.y+offsetY, - offsetZ);
        transform.position = Vector3.Lerp(self2Dpos,
            other2Dpos, followTime * Time.fixedDeltaTime);
    }
}
