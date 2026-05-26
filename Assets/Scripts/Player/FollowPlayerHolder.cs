using UnityEngine;

public class FollowPlayerHolder : MonoBehaviour
{
    public Transform PlayerPos;
    public CustomInputs playerControls;
    
    public Vector3 targetPos;
    private Vector3 realVelocity = new Vector3(2, 0, 0);

    public float offset = 3f;
    public float smoothTimeX = 0.25f;
    
    private float realOffset = 0f;

    private void OnEnable()
    {
        if (playerControls == null)
            playerControls = new CustomInputs();
        
        playerControls.Enable();
    }
    
    private void OnDisable()
    {
        playerControls.Disable();
    }

    void LateUpdate()
    {   
        if (playerControls.Player.Direction.ReadValue<Vector2>().x > 0.1)
            realOffset = -offset;
        else if (playerControls.Player.Direction.ReadValue<Vector2>().x < -0.1)
            realOffset = offset;
        else
            realOffset = 0f;
        targetPos = new Vector3(PlayerPos.position.x + realOffset, PlayerPos.position.y, PlayerPos.position.z);
        float newX = Mathf.SmoothDamp(transform.position.x, targetPos.x, ref realVelocity.x, smoothTimeX);
        transform.position = new Vector3(newX, PlayerPos.position.y, 0f);
    }
}